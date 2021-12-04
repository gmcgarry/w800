#include <stdint.h>

#define __IOM	volatile
#define __IM	volatile
#define __OM	volatile

typedef struct
{
    __IOM uint32_t CLK_EN;
    __IOM uint32_t CLK_MASK;
    __IOM uint32_t BBP_CLK;
    __IOM uint32_t RST;
    __IOM uint32_t CLK_DIV;
    __IOM uint32_t CLK_SEL;
    __IOM uint32_t I2S_CLK;
    __IOM uint32_t RST_STATUS;
} RCC_TypeDef;

typedef struct
{
    __IOM uint32_t DATA;
    __IOM uint32_t DATA_B_EN;
    __IOM uint32_t DIR;
    __IOM uint32_t PULLUP_EN;
    __IOM uint32_t AF_SEL;
    __IOM uint32_t AF_S1;
    __IOM uint32_t AF_S0;
    __IOM uint32_t PULLDOWN_EN;
    __IOM uint32_t IS;
    __IOM uint32_t IBE;
    __IOM uint32_t IEV;
    __IOM uint32_t IE;
    __IM uint32_t  RIS;
    __IM uint32_t  MIS;
    __OM uint32_t  IC;
} GPIO_TypeDef;

#define RCC_CLK_EN_GPIO                     (1<<11)

#define DEVICE_BASE_ADDR	0x40000000
#define RCC_BASE    		(DEVICE_BASE_ADDR + 0xE00)

#define HR_APB_BASE_ADDR	(DEVICE_BASE_ADDR + 0x10000)
#define GPIOA_BASE            	(HR_APB_BASE_ADDR + 0x1200)
#define GPIOB_BASE            	(HR_APB_BASE_ADDR + 0x1400)

#define RCC	((RCC_TypeDef *)RCC_BASE)
#define GPIOB	((GPIO_TypeDef *)GPIOB_BASE)

#define LED_PIN     7

int
main(void)
{
    RCC->CLK_EN |= RCC_CLK_EN_GPIO;

    GPIOB->DATA_B_EN = LED_PIN;
    GPIOB->DIR = LED_PIN;
    GPIOB->PULLUP_EN = LED_PIN;
    GPIOB->PULLDOWN_EN &= ~LED_PIN;

    GPIOB->DATA |= LED_PIN;
    
    while (1) {
	for (long i = 1200000; i > 0; i--)
		asm("nop");
    	GPIOB->DATA ^= LED_PIN;
    }
    
    return 0;
}
