#include "main.h"

#define LED_GREEN_ON() GPIO_ResetBits(GPIOB, GPIO_Pin_9)
#define LED_GREEN_OFF() GPIO_SetBits(GPIOB, GPIO_Pin_9)
#define LED_GREEN_TOGGLE() GPIO_ToggleBits(GPIOB, GPIO_Pin_9)

#define LED_RED_ON() GPIO_ResetBits(GPIOB, GPIO_Pin_8)
#define LED_RED_OFF() GPIO_SetBits(GPIOB, GPIO_Pin_8)
#define LED_RED_TOGGLE() GPIO_ToggleBits(GPIOB, GPIO_Pin_8)

void LedInit(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_9; 
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
    GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
    GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL; 
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz; 
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	GPIO_SetBits(GPIOB,GPIO_Pin_8 | GPIO_Pin_9); 
}

void task1(void *pdata) {
    while (1) {
        OSTimeDlyHMSM(0, 0, 0, 500);
        LED_GREEN_TOGGLE();
    }    
}

void task2(void *pdata) {
    while (1) {
        OSTimeDlyHMSM(0, 0, 0, 500);
        LED_RED_TOGGLE();
    } 
}

int main()
{
    LedInit();
    OS_CPU_SysTickInit(168000000 / OS_TICKS_PER_SEC);
    OSInit();
    OS_STK OSTask1Stk[128];
    OS_STK OSTask2Stk[128];
	OSTaskCreate(task1, NULL, &OSTask1Stk[127], 10);
	OSTaskCreate(task2, NULL, &OSTask2Stk[127], 20);
    OSStart();
    while (1)
    {
        OSTimeDlyHMSM(0, 0, 1, 0);
    }
    return 0;
}
