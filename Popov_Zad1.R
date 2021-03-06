# ����� ������ - ��� ������� 16 (���������� ���������) ����������� ����������� ������� � ������ 
# � 2011 ���� ���� ��� ������� ������� ����� �������� ���������� �� ���� ���,
# � 25 ��������� ������������, �� ������ ������� �� �������� �������� ���������� ����������� ���� 10 ��������.
# ������� ������� �����������
setwd("~/R")
#������� ������� ������ 
rm(list=ls())
#������������� ������
library(tidyverse)
library(rnoaa)
library(lubridate)
#��������� ������ ������������
station_data=read.csv("station_data.csv")
#������� ������ ������������
kazan=data.frame(id="kazan",latitude=55.7331,longitude=49.200)
#�������� ������������ � ������ � 25 ��������� ������������ � �������� ��������� ������
kazan_around=meteo_nearby_stations(lat_lon_df = kazan, station_data = station_data,
                                   limit = 25,var = c("TAVG"),
                                   year_min = 2011, year_max = 2011)

# ���������  �������������� ������������ ������ 
kazan_id=kazan_around[["kazan"]][["id"]][1]
summary(kazan_id)
kazan_table=kazan_around[[1]]
summary(kazan_table)
#������� ������� � ��������� ������������
kazan_table = data.frame(kazan_around)
summary(kazan_table)
# �������� �����, � ������������ ������� � ������������ 
all_i=data.frame()
# ������ ���� ����������� ��� ������ �� ���� ������������
all_kazan_meteodata = data.frame()
#������ � ������� ������������
#������� ���� ��� ���������� ������ � 25 ������������
for (v in 1:25)
{
  kazan_id = kazan_around[["kazan"]][["id"]][v]
  #
  data = meteo_tidy_ghcnd(stationid = kazan_id ,
                          var="TAVG",
                          date_min="2011-01-01",
                          date_max="2011-12-31")
  all_kazan_meteodata = bind_rows(all_kazan_meteodata, data)
}
#������� ���������� ������ � ����
write.csv(all_kazan_meteodata, "all_kazan_meteodata.csv")
all_kazan_meteodata
#������� ������ �� ����� all_kazan_data.csv
all_kazan_meteodata=read.csv("all_kazan_meteodata.csv")
#��������� �� ���������� ������ 
str(all_kazan_meteodata)
#������� ������� ���, ����� � ���� 
all_kazan_meteodata = mutate(all_kazan_meteodata, year = year(date), month = month(date), day = day(date))
str(all_kazan_meteodata)
#������� �������� ����������� ������ 10 �������� 
all_kazan_meteodata_tempr =filter(all_kazan_meteodata,tavg>10 ) 
#�������� ���������
str(all_kazan_meteodata_tempr)
#��������� ������� ����� �������� ���������� �� �����, ����� ������� �� 10
all_kazan_meteodata_tempr[,"tavg"]=all_kazan_meteodata_tempr$tavg/10
str(all_kazan_meteodata_tempr) 
#���������� ��� ���� � NA
all_kazan_meteodata_tempr[is.na(all_kazan_meteodata_tempr$tavg), "tavg"]=0
summary(all_kazan_meteodata_tempr)


#���������� �� �������������, ����� � ������� ��� ������ ������ group_by
alldays_kazan=group_by(all_kazan_meteodata_tempr,id, year, month)
#����� ����������� �� ������ ������� 
sumT_months_kazan=summarize(alldays_kazan, tsum=sum(tavg))
summary(sumT_months_kazan)
#C��������� ������ �� ������� 
groups_kazan_month=group_by(sumT_months_kazan, month);groups_kazan_month
#������ �������� �� ������� ��� ���� ������������ � ���� ���
sumT_months=summarize(groups_kazan_month,St=mean(tsum))
sumT_months
#������� St
ST=c(0,0,sumT_months$St)
ST
#������� ������ ��� ������� ������ �� �������� �������
#��������� ��� ������� ����������� 
afi = c(0.00, 0.00, 0.00, 32.11, 26.31, 25.64, 23.20, 18.73, 16.30, 13.83, 0.00, 0.00)
bfi = c(0.00, 0.00, 0.00, 11.30, 9.26, 9.03, 8.16, 6.59, 5.73, 4.87, 0.00, 0.00)
di = c(0.00, 0.00, 0.00, 0.33, 1.00, 1.00, 1.00, 0.32, 0.00, 0.00, 0.00, 0.00)
#����������� ��� ���������� ������ - ������, ��� � ��� ���� ������
y = 1.0
#����������� ������������� ��� �������
Kf = 300
#������������ ������ ��������
Qj = 1600
#����������� "����� ������ �������� � �������� ���������"
Lj = 2.2
#����������� "����������� ��������� ��������"
Ej = 25
#������� ������ ��� ������� ������ �� �������� �������
#��������� ��� ������� ����������� 
afi = c(0.00, 0.00, 0.00, 32.11, 26.31, 25.64, 23.20, 18.73, 16.30, 13.83, 0.00, 0.00)
bfi = c(0.00, 0.00, 0.00, 11.30, 9.26, 9.03, 8.16, 6.59, 5.73, 4.87, 0.00, 0.00)
di = c(0.00, 0.00, 0.00, 0.33, 1.00, 1.00, 1.00, 0.32, 0.00, 0.00, 0.00, 0.00)
#����������� ��� ���������� ������ - ������, ��� � ��� ���� ������
y = 1.0
#����������� ������������� ��� �������
Kf = 300
#������������ ������ ��������
Qj = 1600
#����������� "����� ������ �������� � �������� ���������"
Lj = 2.2
#����������� "����������� ��������� ��������"
Ej = 25
#������� Fi �� �������
Fi = afi + bfi * y * ST
Fi
#������� Yi
#sumT_months = mutate(sumT_months, Yi = ((Fi * di) * Kf) / (Qj * Lj * (100 - Ej)))
#? mutate
Yi = ((Fi * di) * Kf) / (Qj * Lj * (100 - Ej))
Yi
#������ ������, ��� ����� �� �������
Yield = sum(Yi)
Yield
#����������� ��� ���������� ��������� � 2011 ���� ��������� 18.03874 �/��