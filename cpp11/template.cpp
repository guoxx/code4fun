#include <iostream>

template <typename T>
class Foo
{
public:
    static T tvar;
    static int ivar;
    static void print();
};

template<typename T> void Foo<T>::print()
{
    std::cout << ivar << " " << tvar << std::endl;
}

template<typename T> int Foo<T>::ivar{}; // = 100;
template<typename T> T Foo<T>::tvar{}; // = 200.9;

int main(int argc, char* argv[])
{
    Foo<int>::ivar = 101;
    Foo<int>::tvar = 102;
    Foo<float>::ivar = 301;
    Foo<float>::tvar = 302.5;
    Foo<int>::print();
    Foo<float>::print();
   
    return 0;
}
