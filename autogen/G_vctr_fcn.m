function G_vctr_sym = G_vctr_fcn(in1,in2)
%G_VCTR_FCN
%    G_VCTR_SYM = G_VCTR_FCN(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.2.
%    14-Nov-2019 09:16:43

q2 = in1(2,:);
q3 = in1(3,:);
q4 = in1(4,:);
q5 = in1(5,:);
q6 = in1(6,:);
xi7 = in2(7,:);
xi8 = in2(8,:);
xi14 = in2(14,:);
xi15 = in2(15,:);
xi21 = in2(21,:);
xi22 = in2(22,:);
xi28 = in2(28,:);
xi29 = in2(29,:);
xi35 = in2(35,:);
xi36 = in2(36,:);
t2 = sin(1.57079632679);
t3 = cos(q2);
t4 = sin(q3);
t5 = cos(q3);
t6 = sin(q2);
t7 = cos(q4);
t8 = t2.*t3.*t4.*(9.81e2./1.0e2);
t9 = t2.*t5.*t6.*(9.81e2./1.0e2);
t10 = t8+t9;
t11 = sin(q4);
t12 = t2.*t3.*t5.*(9.81e2./1.0e2);
t15 = t2.*t4.*t6.*(9.81e2./1.0e2);
t13 = t12-t15;
t14 = t2.*t7.*t10;
t16 = t2.*t11.*t13;
t17 = t14+t16;
t18 = t2.*t7.*t13;
t23 = t2.*t10.*t11;
t19 = t18-t23;
t20 = cos(q6);
t21 = cos(q5);
t22 = sin(q6);
t24 = t19.*xi21;
t25 = t17.*xi22;
t26 = t17.*t22;
t35 = t19.*t20.*t21;
t27 = t26-t35;
t28 = t17.*t20;
t29 = t19.*t21.*t22;
t30 = t28+t29;
t31 = t30.*xi36;
t32 = t10.*xi14;
t33 = t19.*t21.*xi28;
t34 = sin(q5);
G_vctr_sym = [0.0;t24+t25+t31+t32+t33-t13.*xi15-t27.*xi35-t2.*t3.*xi8.*(9.81e2./1.0e2)+t2.*t6.*xi7.*(9.81e2./1.0e2)-t19.*t34.*xi29;t24+t25+t31+t32+t33-t13.*xi15-t27.*xi35-t19.*t34.*xi29;t24+t25+t31+t33-t27.*xi35-t19.*t34.*xi29;-t17.*t21.*xi29-t17.*t34.*xi28-t17.*t20.*t34.*xi35-t17.*t22.*t34.*xi36;xi35.*(t19.*t20-t17.*t21.*t22)+xi36.*(t19.*t22+t17.*t20.*t21)];