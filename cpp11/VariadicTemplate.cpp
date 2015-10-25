#include <iostream>

using namespace std;

template <typename... TS>
int foo(TS... args)
{
    int f1 = args;
    int f2 = args;
    int f3 = args;
    cout << "f1 == " << f1 << endl;
    cout << "f2 == " << f2 << endl;
    cout << "f3 == " << f3 << endl;
}

int main(int argc, char* argv[])
{
    foo(1, 2, 3);
    return 0;
}
