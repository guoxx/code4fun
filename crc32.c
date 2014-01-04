#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* #define POLY 0x04C11DB7L */
/* #define POLY 0xFFFFFFFF */
#define POLY 0xDB710641

int crc32(void *data, int len){
    int reg = 0;
    char *ptr = (char*)data;
    for(int i = 0; i < len; ++i){
        for(int j = 7; j >= 0; --j){
            int hi_bit = (reg >> 31) & 0x01;
            reg = (reg << 1) | ((ptr[i] >> j) & 0x01);
            if(hi_bit > 0){
                reg = reg ^ POLY;
            }
        }
    }
    return reg;
}

int crc32_2(int crc, unsigned char const *p, size_t len, int polynomial)
{

    int i;
    while (len--) {
        crc ^= *p++;
        for (i = 0; i < 8; i++)
            crc = (crc >> 1) ^ ((crc & 1) ? polynomial : 0);
    }
    return crc;
}

unsigned int crc32_3(unsigned int data)  
{  
    unsigned char p[4];  
    memset(p, 0, sizeof(p));  
    memcpy(p, &data, 4);  
    unsigned int reg = 0, idx = 0;  
    for(int i = 0; i < 32; i++){  
        idx = i/8;  
        int hi = (reg>>31)&0x01; // 取得reg的最高位  
        // 把reg左移1bit，并移入新数据到reg0  
        reg = (reg<<1)| (p[idx]>>7);  
        if(hi) reg = reg^POLY; // hi=1就用reg除以g(x)  
        p[idx]<<=1;  
    }
    return reg;  
}  
int main(){
    int xx = 0x12345678;
    int c32 = crc32((char*)&xx, 4);
    printf("%#010x\n", c32);
    int c32_2 = crc32_2(0, (unsigned char const*)&xx, 4, POLY);
    printf("%#010x\n", c32_2);
    int c32_3 = crc32_3(xx);
    printf("%#010x\n", c32_3);


    /* char *x = (char*)&c32; */
    /* for(int i = 0; i < 4; ++i){ */
    /*     char v = *(x + i); */
    /*     printf("%#04x\n", v); */
    /* } */


    return 0;
}
