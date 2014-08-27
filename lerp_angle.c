#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <assert.h>
#include <time.h>
#include <sys/time.h>

float lerpAngle0(float from, float to, float frac) {
    float x = to - from;
    // TODO: optimization
    // 1. use multipy replace division
    // 2. reimplementation floorf
    float delta = x - 360.0f * (floorf((x + 180.0f) / 360.0f));
    return from + frac * delta;
}

float lerpAngle1(float from, float to, float frac) {
    if (to - from > 180) {
        to = to - 360;
    }
    if (to - from < -180) {
        to = to + 360;
    }
    return from + frac * (to - from);
}

double getTime() {
    struct timeval t;
    gettimeofday(&t, NULL);
    return t.tv_sec + t.tv_usec * 0.000001;
}

double timeStat(int roundCnt, int interpCnt, float (*lerpFunc)(float, float, float)) {
    double total = 0;
    for (int r = 0; r < roundCnt; r = r + 1) {
        float startAngle = rand() % 361;
        float endAngle = rand() % 361;

        float fracDelta = 1.0f / interpCnt;
        float frac = 0.0f;

        double t0 = getTime();
        for (int i = 0; i < interpCnt; i = i + 1) {
            lerpFunc(startAngle, endAngle, frac);
            frac = frac + fracDelta;
        }
        double t1 = getTime();
        total = total + t1 - t0;
    }
    return total;
}

int main(int argc, char **argv) {
    int seed = (int)time(NULL);

    int roundCnt = 1000;
    int interpCnt = 1000000;

    srand(seed);
    double t0 = timeStat(roundCnt, interpCnt, lerpAngle0);
    srand(seed);
    double t1 = timeStat(roundCnt, interpCnt, lerpAngle1);

    printf("t0 = %lf, t1 = %lf", t0, t1);

    return 0;
}
