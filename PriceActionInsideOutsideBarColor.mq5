//+------------------------------------------------------------------+
//|                             PriceActionInsideOutsideBarColor.mq5 |
//|                                                      Versão: 1.0 |
//|             Copyright 2020, Eduardo Correia da Silva (Amiguinho) |
//|               https://www.linkedin.com/in/eduardocorreiadasilva/ |
//|                                              Feito para estudos: |
//|                                * BMAX https://home.bmax.academy/ |
//|                                    * SST  https://app.sst.trade/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Eduardo Correia da Silva (Amiguinho)"
#property version   "1.0"
#property link      "https://www.linkedin.com/in/eduardocorreiadasilva/"
 
#property description "Um indicador de regra de coloração para Inside Bar e/ou Outside Bar."
#property description " "
#property description " "
#property description "Feito para estudos de Price Action na BMAX e no SST."
#property description "BMAX https://home.bmax.academy/"
#property description "SST  https://app.sst.trade/"
#property description "LinkedIn https://www.linkedin.com/in/eduardocorreiadasilva/"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   1
//--- plot candles
#property indicator_label1  "Cor da barra de baixa e alta"
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  clrTomato,clrMediumSeaGreen

#property script_show_inputs
enum EnumOpcao 
  {
   INSIDE =0,     // Apenas Inside Bar
   OUTSIDE=1,     // Apenas Outside Bar
   AMBAS  =2,     // Ambas: Inside e Outside Bar
  };
input EnumOpcao opcao = AMBAS;

double candlesOpenBuffer[];
double candlesHighBuffer[];
double candlesLowBuffer[];
double candlesCloseBuffer[];
double candlesColors[];


int OnInit(){

   SetIndexBuffer(0,candlesOpenBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,candlesHighBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,candlesLowBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,candlesCloseBuffer,INDICATOR_DATA);
   SetIndexBuffer(4,candlesColors,INDICATOR_COLOR_INDEX);

   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){

   int start;
   if (prev_calculated ==0){
      start=1;
   } else {
      start=prev_calculated-1;
   }

   for(int i=start; i<rates_total; i++){
      DefineColorCandle(i,close,open,high,low);
   }

   return(rates_total);
}

void DefineColorCandle(int index,
                       const double &close[],
                       const double &open[],
                       const double &high[],
                       const double &low[]){
                       
   DefineBuffersCandle(index,close,open,high,low);
 
   bool candleOutside = low[index] < low[index - 1] && high[index] > high[index - 1];
   bool candleInside  = low[index] > low[index - 1] && high[index] < high[index - 1];
   
   bool candleBull = close[index] > open[index];
   bool candleBear = close[index] < open[index];


   if (opcao != AMBAS){
      if (opcao == INSIDE && candleOutside){
         return;
      }
      if (opcao == OUTSIDE && candleInside){
         return;
      }
   }

   if ((candleOutside || candleInside) && candleBull){
       candlesColors[index] = 1;
   }
   if ((candleOutside || candleInside) && candleBear){
       candlesColors[index] = 0;
   }

}

void DefineBuffersCandle(int index,
                         const double &close[],
                         const double &open[],
                         const double &high[],
                         const double &low[]){
                         
   candlesOpenBuffer[index] = open[index];
   candlesHighBuffer[index] = high[index];
   candlesLowBuffer[index]=low[index];
   candlesCloseBuffer[index]=close[index];
}
