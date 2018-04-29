#include <stdio.h>
#include <stdlib.h>
#define N 5

typedef struct sheet{
    char name[10];
    char chinese;
    char math;
    char english;
    char average;
    short rank;
}XINXI;

XINXI marklist[N];

//����Ϊ�ṹ�����׵�ַ�Լ�ѧ������
extern void _JISUAN(XINXI *, short x);
extern void _PAIXU(XINXI *, short x);

void menu(void);//�˵���ʾ����
void shuru(void);//�ɼ���¼�뺯��
void shuchu(void);//�ɼ����������
int main(void)
{
    int i;
    while(1)
    {
        menu();
        scanf("%d", &i);
        switch(i)
        {
            case 1: shuru();
                    break;
            case 2: _JISUAN(marklist, N);//���û���ӳ��򣬼���ƽ���ɼ�
                    break;
            case 3: _PAIXU(marklist, N);//���û���ӳ��򣬶Գɼ���������
                    break;
            case 4: shuchu();
                    break;
            case 5: return 0;
        }
    }

}

//�˵���ʾ����
void menu(void)
{
    printf("Please choose what you want to do:(1-5)\n");
    printf("1.Enter name and grades(# = stop)   \n");
    printf("2.Calculate average\n");
    printf("3.Rank from high to low\n");
    printf("4.Print report card\n");
    printf("5.EXIT\n");
}

//�ɼ���¼�뺯��
void shuru(void)
{
    int i;
    for(i = 0; i < N; i++)
        scanf("%s%d%d%d",marklist[i].name, &marklist[i].chinese, &marklist[i].math,  &marklist[i].english);
}

//�ɼ����������
void shuchu(void)
{
    int i;
    printf("NAME         CHINESE      MATH   ENGLISH   AVERAGE      RANK\n");
    for(i = 0; i < N; i++)
        printf("%-10s%10d%10d%10d%10d%10d\n", marklist[i].name,  marklist[i].chinese, marklist[i].math, marklist[i].english, marklist[i].average, marklist[i].rank);
}

