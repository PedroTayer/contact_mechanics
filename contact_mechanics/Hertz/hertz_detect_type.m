function type=hertz_detect_type(Rx1, Rx2, Ry1, Ry2)
  % 0 linear
  % 1 pontual
  
  vector=[Rx1, Rx2, Ry1, Ry2];
  
  qt_infs=length(vector(vector==Inf));
  if qt_infs==3
    type=0;
    return
  end
  if qt_infs==2
    if (Rx1==Inf && Rx2==Inf) || (Ry1==Inf && Ry2==Inf)
      type = 0;
      return
    end
  end
  type = 1;
end
