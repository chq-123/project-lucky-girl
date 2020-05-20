data<-read.csv("hushen.csv")
data_time<-ts(data$����)
plot.ts(data_time, ylab = "Closing Price", main = "after COVID-19")
#kȡ���ݵ�����ƽ����1310*��1/2��=36

library(tsfknn)
par(mfrow = c(2,1))
##knn�ع��ԭ=ԭ������lags��ֵ��Ϊ����
predknn_after_covid <- knn_forecasting(data_time, h = 65, lags = 1:30, k = 36, msas = "MIMO")
#h-Ԥ����ٸ�ֵ��lags-ÿ�����ݶ�����30��ֵ���;�ҵ�36�����������
plot(predknn_after_covid, main = "After COVID-19")
plot(data_time)
plot(predknn_after_covid)
#���㵥�����ز���񾭽ڵ���
alpha <- 1.5^(-10)
hn_after_covid <- length(data$����)/(alpha*(length(data$����) + 65))
##Ӧ�õ������ز��ǰ��������ģ�ͣ���ģ�������ڵ�����ʱ������
#BoxCox.lambda������ת��Ϊ��̬�ֲ�
library(MASS)
library(forecast)
lambda_after_covid <- BoxCox.lambda(data$����)
dnn_pred_after_covid <- nnetar(data$����, size = hn_after_covid, lambda = lambda_after_covid)
dnn_forecast_after_covid <- forecast(dnn_pred_after_covid, h = 65, PI = TRUE)
plot(dnn_forecast_after_covid, title = "after COVID-19")
par(mfrow=c(3,1))
##����������ĺ���
rmse<-function(y,f){
  sqrt(mean((y-f)^2))}

##��Ԥ��ֵ�������
dnn_predict<-dnn_forecast_after_covid[["mean"]]
predict_knn<-predknn_after_covid[["neighbors"]]
predicr_frame<-data.frame(knn_predict,knn_predict)
