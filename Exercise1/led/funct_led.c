/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           funct_led.h
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        High level led management functions
** Correlated files:    lib_led.c, funct_led.c
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/

#include "lpc17xx.h"
#include "led.h"

#define LED_NUM     8                   /* Number of user LEDs                */
const unsigned long led_mask[] = { 1UL<<0, 1UL<<1, 1UL<<2, 1UL<< 3, 1UL<< 4, 1UL<< 5, 1UL<< 6, 1UL<< 7 };

extern unsigned char led_value;

/*----------------------------------------------------------------------------
  Function that turns on requested LED
 *----------------------------------------------------------------------------*/
void LED_On(unsigned int num) {//num è la posizione del led, utilizzando quella posizione va ad accedere il led
 
  LPC_GPIO2->FIOPIN |= led_mask[num];//fa a scrivere il valore num nella porta 2
	led_value = LPC_GPIO2->FIOPIN;//salva un valore led_value che è importante perchè serve per tenere traccia del valore che si sta mostrando nel led
																//quindi dice che valore sto mostrando nei led, quindi se tutti sono spenti allora 0 se uno è acceso 1
}

/*----------------------------------------------------------------------------
  Function that turns off requested LED
 *----------------------------------------------------------------------------*/
void LED_Off(unsigned int num) {

  LPC_GPIO2->FIOPIN &= ~led_mask[num];
	led_value = LPC_GPIO2->FIOPIN;
}

/*----------------------------------------------------------------------------
  Function that outputs value to LEDs
 *----------------------------------------------------------------------------*/
void LED_Out(unsigned int value) {//dato un valore tra 0 e 255 accendo o spengo i led che restano ad 1 di quel processo lì, con 255 spengo tutti i led
  int i;

  for (i = 0; i < LED_NUM; i++) {
    if (value & (1<<i)) {
      LED_On (i);
    } else {
      LED_Off(i);
    }
  }
	led_value = value;
}
