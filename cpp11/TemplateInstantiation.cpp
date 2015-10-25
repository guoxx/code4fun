#include <stdio.h>

// template function instantiation
template<typename T>
const T& max(const T& a, const T& b)
{
    return a >= b ? a : b;
}

template<typename T>
void print(const T& obj)
{
    printf("object: %p\n", &obj);
}

template<>
void print<float>(const float& obj)
{
    printf("float object: %f\n", obj);
}

// whole class instantiation
template<typename T>
class Printer
{
public:
    Printer(const T& obj)
        : val{obj}
    {}

    int operator() ()
    {
        return printf("default printer %p", &val);
    }
    
private:
    T val;
};

template<>
int Printer<float>::operator() ()
{
    return printf("float printer %f", val);
}

int main(int argc, char* argv[])
{
    print(max<float>(1.0f, 2.0f));
    {
        Printer<float> p{100.0f};
        p();
    }
    {
        Printer<double> p{100.0};
        p();
    }
    return 0;
}
