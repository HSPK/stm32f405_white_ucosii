#include "main.h"

#define LED_GREEN_ON() GPIO_ResetBits(GPIOB, GPIO_Pin_9)
#define LED_GREEN_OFF() GPIO_SetBits(GPIOB, GPIO_Pin_9)
#define LED_GREEN_TOGGLE() GPIO_ToggleBits(GPIOB, GPIO_Pin_9)

#define LED_RED_ON() GPIO_ResetBits(GPIOB, GPIO_Pin_8)
#define LED_RED_OFF() GPIO_SetBits(GPIOB, GPIO_Pin_8)
#define LED_RED_TOGGLE() GPIO_ToggleBits(GPIOB, GPIO_Pin_8)

void delay_ms(volatile u16 nms) {
    u16 i, j = 42000;
    for (i = 0; i < nms; i++) {
        j = 42000;
        while (j--)
            ;
    }
}

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

int main()
{
    // SystemInit();
    LedInit();

	while (1) {
		delay_ms(500);
		LED_GREEN_ON();
        LED_RED_OFF();
        delay_ms(500);
        LED_GREEN_OFF();
        LED_RED_ON();
	}
    return 0;
}
