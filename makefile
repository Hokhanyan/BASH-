export EXECUTABLE := pontem

default : $(EXECUTABLE)

export DEBUG_FLAGS ?= -o3
export SOURCE_FILES := $(wildcard *.cpp)
export OBJ_FILES := $(patsubst %.cpp, %.o, $(SOURCE_FILES))
export DEP_FILES := $(patsubst %.cpp, %.dep, $(SOURCE_FILES))
export COV_FILES := $(patsubst %.cpp, %, $(SOURCE_FILES))
export GCNO_FILES := $(wildcard *.gcno)
export GCDA_FILES := $(wildcard *.gcda)
export GCOV_FILES := $(wildcard *gcov)
export PROF_FILES := gmon.out
export TEMP_FILES := $(GCOV_FILES) $(EXECUTABLE) $(GCNO_FILES) $(GCDA_FILES)  $(OBJ_FILES)

$(EXECUTABLE) : $(OBJ_FILES)
	@echo "LINKING THE EXECUTABLE"
	@g++ $(DEBUG_FLAGS) $^ -o $@

%.o : %.cpp
	@echo "COMPILING" $<
	@g++ $(DEBUG_FLAGS) -c $< -o $@

%.dep : %.cpp
	@echo "GENERATING DEPENDENCIES FOR" $<
	@g++ -MM $< -o $@

.PHONY : clean
clean:
	@echo "CLEANING THE TEMPORARY FILES"
	@-rm $(TEMP_FILES) > /dev/null

.PHONY : test
test : $(EXECUTABLE)
	@echo "RUNNING THE PROGRAM"
	@./$(EXECUTABEL)

.PHONY : debug
debug: clean
	@echo "BUILDING THE DEBUG VERSION"
	@$(MAKE) DEBUG_FLAGS="-g"
	@echo "RUNNING GDB"
	@gdb ./$(EXECUTABLE)

.PHONY :release
release: clean
	@echo "BUILDING THE RELEASE VERSION"
	@export  DEBUG_FILES="-O3" && $(MAKE)

.PHONY : profile
	profile : clean
	@echo "BUILIDING THE PROFILE VERSION"
	@$(MAKE) DEBUGE_FILES="-pg"
	@./$(EXECUTABLE)
	@gprof ./$(EXECUTABLE)

.PHONY : coverage
coverage : clean
	@echo "BUILDING WITH GCOV"
	@$(MAKE) DEBUG_FLAGS="-g --coverage"
	@echo "RUNNING THE APP IN COVERAGE MODE"
	@./$(EXECUTABLE)
	echo "RUNNING THE COVERAGE TOOL"
	@gcov $(COV_FILES)

-include @(DEP-FILES)
