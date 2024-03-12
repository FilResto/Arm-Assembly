#include "button.h"
#include "lpc17xx.h"

#include "../led/led.h"
//#include "../main/sample.c"


// Assuming button mappings:
// INT0 (EINT0) -> Reset
// KEY1 (EINT1) -> Increment
// KEY2 (EINT2) -> Decrement
signed int counter=0;
extern unsigned char led_value;

void EINT0_IRQHandler (void)	//INTO Turns on LED0 when EINT0 is triggered, mettere a posto questa che mi accende tutti i led anziche spegnerli
{
	counter=0;
	led_value=counter;
	LED_Out(0);//mi spegne tutti i led
	//LED_On(0);
  LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         *///quando interrompo succede che l interruzione resta attiva o pending
}																																			//infatti questa riga scrive ad 1 in una certa posizione in EXINT che mi gestisce le interruzioni
																																			//quindi dico "grazie ho finito l interruzione e puoi ritornare"

void EINT1_IRQHandler (void)	  //KEY1 Turns on LED1 when EINT1 is triggered, // l interruzione 1 accende il secondo bit	 
{
	counter++;
	led_value=counter;
	LED_Out(led_value);
  //LED_On(1);
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)//KEY2 Turns off LED0 and LED1 when EINT2 is triggered	  //l interruzione due li spenge entrambi 
{
	counter--;
	led_value=counter;
	LED_Out(led_value);
	//LED_Off(0);
	//LED_Off(1);
  LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */    
}


