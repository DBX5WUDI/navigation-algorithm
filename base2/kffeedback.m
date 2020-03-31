function [kf, ins] = kffeedback(kf, ins, T_fb)
% Kalman filter state estimation feedback to SINS.
%
% Prototype: [kf, ins] = kffeedback(kf, ins, T_fb, fbstring)
% Inputs: kf - Kalman filter structure array
%         ins - SINS structure array
%         T_fb - feedback time interval
% Outputs: kf, ins - Kalman filter % SINS structure array after feedback
%
% See also  kfinit, kffk, kftypedef.
    if kf.T_fb~=T_fb
        kf.T_fb = T_fb;
        xtau = kf.xtau;
    	xtau(kf.xtau<kf.T_fb) = kf.T_fb;  kf.coef_fb = kf.T_fb./xtau; 
    end
    xfb_tmp = kf.coef_fb.*kf.xk;
    ins.vn = ins.vn - xfb_tmp(4:6);
    kf.xk(4:6) = kf.xk(4:6) - xfb_tmp(4:6);
    kf.xfb(4:6) = kf.xfb(4:6) + xfb_tmp(4:6);  % record total feedback
    [ins.qnb, ins.att, ins.Cnb] = attsyn(ins.qnb);
    ins.avp = [ins.att; ins.vn; ins.pos];
 