def lerp(a, b):
    def f(x):
        return a + x * (b - a)
    return f

def main():
    val = lerp(1.0, 10.0)
    print val(0.0)
    print val(1.0)

if __name__ == "__main__":
    main()

