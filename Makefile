include common.mk
OBJ_DIR=obj
EXE_DIR=bin

SRC_SRC=fp.cpp
TEST_SRC=fp_test.cpp ec_test.cpp fp_util_test.cpp window_method_test.cpp elgamal_test.cpp fp_tower_test.cpp gmp_test.cpp
ifeq ($(CPU),x86-64)
  TEST_SRC+=fp_generator_test.cpp mont_fp_test.cpp
endif
SAMPLE_SRC=bench.cpp ecdh.cpp random.cpp rawbench.cpp vote.cpp

##################################################################
MCL_LIB=lib/libmcl.a
all: $(MCL_LIB)

ASM_SRC_TXT=once.txt all.txt long.txt short.txt mul.txt
LIB_OBJ=$(OBJ_DIR)/$(CPU).o $(OBJ_DIR)/fp.o
LLVM_VER=-3.6
LLVM_LLC=llc$(LLVM_VER)
LLVM_OPT=opt$(LLVM_VER)

# CPU is used for llvm
# see $(LLVM_LLC) --version
LLVM_FLAGS=-march=$(CPU)

HAS_BMI2=$(shell cat "/proc/cpuinfo" | grep bmi2 >/dev/null && echo "1")
ifeq ($(HAS_BMI2),1)
  LLVM_FLAGS+=-mattr=bmi2
endif

$(MCL_LIB): $(LIB_OBJ)
	$(AR) $@ $(LIB_OBJ)

$(OBJ_DIR)/$(CPU).o: src/$(CPU).s
	$(MKDIR) $(OBJ_DIR) $(EXE_DIR)
	$(PRE)$(CXX) -c $< -o $@ $(CFLAGS)

src/base$(BIT).ll: $(addprefix src/, gen.py $(ASM_SRC_TXT))
	cd src && python gen.py $(BIT)

src/$(CPU).s: src/base$(BIT).ll
	$(LLVM_OPT) -O3 -o - $< | $(LLVM_LLC) -O3 -o $@ $(LLVM_FLAGS)

##################################################################

VPATH=test sample src

.SUFFIXES: .cpp .d .exe

$(OBJ_DIR)/%.o: %.cpp
	$(PRE)$(CXX) $(CFLAGS) -c $< -o $@ -MMD -MP -MF $(@:.o=.d)

$(EXE_DIR)/%.exe: $(OBJ_DIR)/%.o $(MCL_LIB)
	$(PRE)$(CXX) $< -o $@ $(MCL_LIB) $(LDFLAGS)

SAMPLE_EXE=$(addprefix $(EXE_DIR)/,$(SAMPLE_SRC:.cpp=.exe))
sample: $(SAMPLE_EXE) $(MCL_LIB)

TEST_EXE=$(addprefix $(EXE_DIR)/,$(TEST_SRC:.cpp=.exe))
test: $(TEST_EXE)
	@echo test $(TEST_EXE)
	@sh -ec 'for i in $(TEST_EXE); do $$i|grep "ctest:name"; done' > result.txt
	@grep -v "ng=0, exception=0" result.txt || echo "all unit tests are ok"

clean:
	$(RM) $(MCL_LIB) src/base$(BIT).ll src/$(CPU).s $(OBJ_DIR)/* $(EXE_DIR)/*.exe

ALL_SRC=$(SRC_SRC) $(TEST_SRC) $(SAMPLE_SRC)
DEPEND_FILE=$(addprefix $(OBJ_DIR)/, $(ALL_SRC:.cpp=.d))
-include $(DEPEND_FILE)

# don't remove these files automatically
.SECONDARY: $(addprefix $(OBJ_DIR)/, $(ALL_SRC:.cpp=.o))
 
