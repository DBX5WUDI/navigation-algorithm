function qo = qconj(qi)
%功  能：姿态四元数求逆
%输  入：qi - 姿态四元数
%输  出: qo - qi的逆
    qo = [qi(1); -qi(2:4)];