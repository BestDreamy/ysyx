LIB += $(shell llvm-config --cxxflags) -fPIE 
LIB += $(shell llvm-config --libs)
CXX_FLAGS += -fsanitize=address -g -fno-omit-frame-pointer