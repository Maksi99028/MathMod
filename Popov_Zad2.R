#����� ������
# �������� ������ ������������� �������� ��������� 
#������� ������� ����� ���� �� ������ 2013 ���� 
#�� ������ ��������� ������� ������������ ���������

rm(list=ls())

#��������� ����������
library("tidyverse")
library("tidyr")
library("stringr")
library("dplyr")
library("tibble")
library("readr")

#������ ������ �� �����, ���������� ������ ������, �������� ��������� 'NA', 
#������ � ��������������� ��������� �������� �� NA, ���������� ������ � "[" 
eddypro = read_csv("eddypro.csv", skip = 1, na=c("","NA","-9999","-9999.0"), comment=c("["))
eddypro = eddypro[-1,]
eddypro
# ������ ������ ����� ���������� ���

# ��������� �� ���� ���������� � ��� ����� ������������ �������� glimpse(), 
#������� ����� �������� ������������ ������ ��������� ����������, 
#������ ��� ���� ������������ ������� ������
glimpse(eddypro)

# ��� ������������ ������������ ����� ��������, ��� ���������� roll �������� ������ NA, � ������ ����� ������ ������ ��� ��� �������. ��������� �� ��� � ������� ������� select:
eddypro = select(eddypro, -(roll))

# � ����� ������� �������� ����� ���������� ���� char, ������� �������� ������������� ��������, �.�. �� �����, ��� ������� ��� �� ����������, ����������� �� ��� � �������:
eddypro = eddypro %>% mutate_if(is.character, factor)

# ��� ����� �� ���������� ������� str_replace_all �� ������ stringr. ��� ���������, ��������� �������� ������� ���������, �������� �������� ��� �������:

names(eddypro) = names(eddypro) %>% 
  str_replace_all("[!]","_emph_") %>% 
  str_replace_all("[?]","_quest_") %>% 
  str_replace_all("[*]","_star_") %>% 
  str_replace_all("[+]","_plus_") %>%
  str_replace_all("[-]","_minus_") %>%
  str_replace_all("[@]","_at_") %>%
  str_replace_all("[$]","_dollar_") %>%
  str_replace_all("[#]","_hash_") %>%
  str_replace_all("[/]","_div_") %>%
  str_replace_all("[%]","_perc_") %>%
  str_replace_all("[&]","_amp_") %>%
  str_replace_all("[\\^]","_power_") %>%
  str_replace_all("[()]","_") 
glimpse(eddypro)

# ������ na
eddypro = drop_na(eddypro)
# ����� ������� ��� ���������� ���� numeric.
sapply(eddypro,is.numeric)
# ������� ������� �����
eddypro = filter(eddypro, daytime==TRUE)
# �������� ������� ���������� ������ �� ������������ ��� �������
eddy_numeric = eddypro[,sapply(eddypro,is.numeric)]
# ��� ���� ����� ����� �������� ������� ���������� ��� ��������� �������
eddy_non_numeric = eddypro[,!sapply(eddypro,is.numeric)]

# ������ �� ����� ���������� � ��������������� �������

cor_td = cor(eddy_numeric)
cor_td
#���������� ���������� �������� ������ ���������������� �.�. ��� �������� � ���� �������, 
#������� ����������� ������� � �������, ������� ������������ ��� �������, 
#� �� ���� ������� ������ �� ����� �����(����������) ��� ������� �������� 
#������������ ������������ ���� ������ 0,1 (������ �������)

cor_td = cor(drop_na(eddy_numeric)) %>% as.data.frame %>% select(h2o_flux)
vars = row.names(cor_td)[cor_td$h2o_flux^2 > .1] %>% na.exclude

#�������� ���������������� ����������
row_numbers = 1:length(eddy_numeric$h2o_flux)
teach = sample(row_numbers, floor(length(eddy_numeric$h2o_flux)*.7))
test = row_numbers[-teach]
teaching_tbl = eddy_numeric[teach,]
testing_tbl = eddy_numeric[test,]

# ������ 1 �� ��������� �������
mod1 = lm(h2o_flux~ (.) , data = teaching_tbl)

#������������
coef(mod1)
#�������
resid(mod1)
#������������� ��������
confint(mod1)
#P-�������� �� ������
summary(mod1)
#������������� ������
anova(mod1)
#����������� ������������� ������:
plot(mod1)

# ������ 2
mod2 = lm ( h2o_flux~ DOY + file_records + Tau+qc_Tau + rand_err_Tau + H +qc_H 
            + rand_err_H + LE + qc_LE + rand_err_LE + co2_flux + qc_h2o_flux
            + rand_err_co2_flux + rand_err_h2o_flux + H_strg + co2_v_minus_adv 
            + h2o_v_minus_adv + co2_molar_density + co2_mole_fraction + co2_mixing_ratio 
            + h2o_molar_density + h2o_mole_fraction + h2o_mixing_ratio + h2o_time_lag 
            + sonic_temperature + air_temperature + air_pressure + air_density 
            + air_heat_capacity + air_molar_volume + water_vapor_density + e + es 
            + specific_humidity + RH + VPD + Tdew + u_unrot + v_unrot + w_unrot + u_rot 
            + v_rot + w_rot + max_speed + yaw + pitch + u_star_ + TKE + L + bowen_ratio 
            + T_star_ + x_peak + x_offset + x_30_perc_ + x_50_perc_ + x_90_perc_ + un_Tau 
            + Tau_scf + un_H + H_scf + un_LE + LE_scf + un_co2_flux + un_h2o_flux 
            + w_spikes + ts_spikes + mean_value + v_var + ts_var + h2o_var + w_div_co2_cov 
            + h2o_1 + co2_signal_strength_7200 + h2o_signal_strength_7200, data = teaching_tbl)

coef(mod2)
resid(mod2)
confint(mod2)
summary(mod2)
anova(mod2)
anova(mod2, mod1)
plot(mod2) 


# ������ 3
mod3 = lm ( h2o_flux~ DOY + file_records + Tau+qc_Tau + rand_err_Tau + H +qc_H + rand_err_H 
            + LE + qc_LE + rand_err_LE + co2_flux + qc_h2o_flux + rand_err_co2_flux 
            + rand_err_h2o_flux + H_strg + h2o_v_minus_adv + co2_molar_density + co2_mole_fraction 
            + h2o_molar_density + h2o_mole_fraction + h2o_mixing_ratio + h2o_time_lag 
            + sonic_temperature + air_temperature + air_pressure + air_density + air_heat_capacity 
            + air_molar_volume + water_vapor_density + e + es + specific_humidity + RH + VPD 
            + Tdew + u_unrot + v_unrot + w_unrot + u_rot + v_rot + max_speed + yaw + pitch 
            + u_star_ + TKE + L + T_star_ + x_peak + x_offset + x_30_perc_ + x_50_perc_ + x_90_perc_ 
            + un_Tau + Tau_scf + un_H + H_scf + un_LE + LE_scf + un_co2_flux + un_h2o_flux 
            + w_spikes + ts_spikes + ts_var + w_div_co2_cov + h2o_1 + co2_signal_strength_7200 
            + h2o_signal_strength_7200, data = teaching_tbl)

coef(mod3)
resid(mod3)
confint(mod3)
summary(mod3)
anova(mod3)
anova(mod3, mod2)
plot(mod3)


# ������ 4
mod4 = lm ( h2o_flux~ DOY + file_records + Tau+qc_Tau + rand_err_Tau + H + qc_H + rand_err_H 
            + LE + qc_LE + rand_err_LE + co2_flux + qc_h2o_flux + rand_err_co2_flux 
            + rand_err_h2o_flux + H_strg + co2_molar_density + co2_mole_fraction + h2o_mole_fraction 
            + h2o_mixing_ratio + h2o_time_lag + sonic_temperature + air_temperature + air_pressure 
            + air_density + air_heat_capacity + air_molar_volume + water_vapor_density + e + es 
            + specific_humidity + RH + VPD + Tdew + u_unrot + v_unrot + w_unrot + u_rot + v_rot 
            + max_speed + yaw + pitch + u_star_ + TKE + L + T_star_ + x_peak + x_offset + x_30_perc_ 
            + x_50_perc_ + x_90_perc_ + un_Tau + Tau_scf + un_H + H_scf + un_LE + LE_scf + un_co2_flux 
            + un_h2o_flux + w_spikes + ts_spikes + ts_var + w_div_co2_cov + h2o_signal_strength_7200, data = teaching_tbl)

coef(mod4)
resid(mod4)
confint(mod4)
summary(mod4)
anova(mod4)
anova(mod4, mod3)
plot(mod4)


# ������ 5
mod5 = lm ( h2o_flux~ DOY + file_records + Tau+qc_Tau + rand_err_Tau + H +qc_H + rand_err_H 
            + LE + qc_LE + rand_err_LE + co2_flux + qc_h2o_flux + rand_err_co2_flux + rand_err_h2o_flux 
            + H_strg + co2_molar_density + co2_mole_fraction + h2o_mixing_ratio + h2o_time_lag 
            + sonic_temperature + air_temperature + air_pressure + air_density + air_heat_capacity 
            + air_molar_volume + water_vapor_density + e + es + specific_humidity + RH + VPD + Tdew 
            + u_unrot + v_unrot + w_unrot + u_rot + v_rot + max_speed + yaw + pitch + u_star_ 
            + TKE + L + T_star_ + x_peak + x_offset + x_30_perc_ + x_50_perc_ + x_90_perc_ + un_Tau 
            + Tau_scf + un_H + H_scf + un_LE + LE_scf + un_co2_flux + un_h2o_flux + w_spikes + ts_spikes 
            + ts_var + w_div_co2_cov, data = teaching_tbl)

coef(mod5)
resid(mod5)
confint(mod5)
summary(mod5)
anova(mod5)
anova(mod5, mod4)
plot(mod5)



# ������ 6
mod6 = lm ( h2o_flux~ DOY + file_records + Tau+qc_Tau + rand_err_Tau + H +qc_H + rand_err_H + LE 
            + qc_LE + rand_err_LE + co2_flux + qc_h2o_flux + rand_err_co2_flux + rand_err_h2o_flux 
            + H_strg + co2_molar_density + co2_mole_fraction + h2o_time_lag + sonic_temperature 
            + air_temperature + air_pressure + air_density + air_heat_capacity + air_molar_volume 
            + water_vapor_density + e + es + RH + VPD + Tdew + u_unrot + v_unrot + w_unrot + u_rot 
            + v_rot + max_speed + yaw + pitch + u_star_ + TKE + L + T_star_ + x_peak + x_offset 
            + x_30_perc_ + x_50_perc_ + x_90_perc_ + un_Tau + Tau_scf + un_H + H_scf + un_LE + LE_scf 
            + un_co2_flux + un_h2o_flux + w_spikes + ts_spikes + ts_var + w_div_co2_cov, data = teaching_tbl)

coef(mod6)
resid(mod6)
confint(mod6)
summary(mod6)
anova(mod6)
anova(mod6, mod5)
plot(mod6)



# ������ 7
mod7 = lm ( h2o_flux~ DOY + file_records + Tau+qc_Tau + rand_err_Tau + H +qc_H + rand_err_H + LE 
            + qc_LE + rand_err_LE + co2_flux + qc_h2o_flux + rand_err_co2_flux + rand_err_h2o_flux 
            + H_strg + co2_molar_density + co2_mole_fraction + h2o_time_lag + sonic_temperature 
            + air_temperature + air_pressure + air_density + air_heat_capacity + air_molar_volume 
            + water_vapor_density + es + RH + Tdew + u_unrot + v_unrot + w_unrot + u_rot + v_rot 
            + max_speed + yaw + pitch + u_star_ + TKE + L + T_star_ + x_peak + x_offset + x_30_perc_ 
            + x_50_perc_ + x_90_perc_ + un_Tau + Tau_scf + un_H + H_scf + un_LE + LE_scf + un_co2_flux 
            + un_h2o_flux + w_spikes + ts_spikes + ts_var + w_div_co2_cov, data = teaching_tbl)

coef(mod7)
resid(mod7)
confint(mod7)
summary(mod7)
anova(mod7)
anova(mod7, mod6)
plot(mod7)


#�������������� ������ ���������� ����������� � �������� ������
cor_teaching_tbl = select(teaching_tbl, DOY, file_records, Tau, qc_Tau, rand_err_Tau, H, qc_H, 
                          rand_err_H, LE, qc_LE, rand_err_LE, co2_flux, qc_h2o_flux, rand_err_co2_flux, 
                          rand_err_h2o_flux, H_strg, co2_molar_density, co2_mole_fraction, 
                          h2o_time_lag, sonic_temperature, air_temperature, air_pressure, air_density,
                          air_heat_capacity, air_molar_volume, water_vapor_density, es, RH, Tdew, u_unrot,
                          v_unrot, w_unrot, u_rot, v_rot, max_speed, yaw, pitch, u_star_, TKE, L, T_star_, 
                          x_peak, x_offset, x_30_perc_, x_50_perc_, x_90_perc_, un_Tau, Tau_scf, un_H, H_scf,
                          un_LE, LE_scf, un_co2_flux, un_h2o_flux, w_spikes, ts_spikes, ts_var, w_div_co2_cov)

#��������� ������� ������������� ����������
cor_td = cor(cor_teaching_tbl) %>% as.data.frame

#���������� �������� �� ���������� ������
#���������� ����� �� ���������� ��������� ������� � ��������� ������������� �������� �� 7 ������
qplot(h2o_flux , h2o_flux, data = teaching_tbl) + geom_line(aes(y = predict(mod3, teaching_tbl)))

#���������� ����� �� ��������� ����������� ������� � ��������� ������������� �������� �� 7 ������
qplot(h2o_flux , h2o_flux, data = testing_tbl) + geom_line(aes(y = predict(mod3, testing_tbl)))

#�������
qplot(DOY, h2o_flux, data = testing_tbl) + geom_line(aes(y = predict(mod7, testing_tbl)))
qplot(Tau, h2o_flux, data = testing_tbl) + geom_line(aes(y = predict(mod7, testing_tbl)))
qplot(co2_flux, h2o_flux, data = testing_tbl) + geom_line(aes(y = predict(mod7, testing_tbl)))