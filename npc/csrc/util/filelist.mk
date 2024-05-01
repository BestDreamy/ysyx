LIB += $(shell llvm-config --cxxflags) -fPIE 
LIB += $(shell llvm-config --libs)