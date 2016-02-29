unit CplxMtrxI;

interface

uses
  IntervalArithmetic32and64;

type
  complexI = record
    re, im : interval
  end;
  cplxvectorI = array of complexI;
  cplxmatrixI = array of array of complexI;

procedure complexmatrixI (n      : Integer;
                         var a  : cplxmatrixI;
                         var x  : cplxvectorI;
                         var st : Integer);

implementation

procedure complexmatrixI (n      : Integer;
                         var a  : cplxmatrixI;
                         var x  : cplxvectorI;
                         var st : Integer);

var i,ih,j,k,n1 : Integer;
    d, m        : interval;
    aa,b,c      : complexI;
    alb         : Boolean;

begin
  if n<1
    then st:=1
    else begin
           st:=0;
           k:=0;
           repeat
             k:=k+1;
             d:=int_read('0');
             for i:=k to n do
               begin
                 b.re:=iabs(a[i,k].re)+iabs(a[i,k].im);
                 if b.re>d
                   then begin
                          d:=b.re;
                          ih:=i
                        end
               end;
             if d=int_read('0')
             then st:=2
             else begin
                      aa:=a[ih,k];
                      alb:=iabs(aa.re)<iabs(aa.im);
                      if alb
                        then begin
                               b.re:=aa.re;
                               aa.re:=aa.im;
                               aa.im:=b.re
                             end;
                      b.re:=aa.im/aa.re;
                      aa.im:=int_read('1')/(b.re*aa.im+aa.re);
                      aa.re:=aa.im*b.re;
                      if not alb
                        then begin
                               b.re:=aa.re;
                               aa.re:=aa.im;
                               aa.im:=b.re
                             end;
                      a[ih,k]:=a[k,k];
                      n1:=n+1;
                      for j:=k+1 to n1 do
                        begin
                          c:=a[ih,j];
                          if d<(iabs(c.re)+iabs(c.im))*int_read('1e-16')
                            then st:=2
                            else begin
                                   a[ih,j]:=a[k,j];
                                   b.re:=c.im*aa.im+c.re*aa.re;
                                   b.im:=c.im*aa.re-c.re*aa.im;
                                   a[k,j]:=b;
                                   for i:=k+1 to n do
                                     begin
                                       c:=a[i,k];
                                       a[i,j].re:=a[i,j].re-c.re*b.re
                                                  +c.im*b.im;
                                       a[i,j].im:=a[i,j].im-c.re*b.im
                                                  -c.im*b.re
                                     end
                                 end
                        end
                    end
           until (k=n) or (st=2);
           if st=0
             then begin
                    x[n]:=a[n,n1];
                    for i:=n-1 downto 1 do
                      begin
                        aa:=a[i,n1];
                        for j:=i+1 to n do
                          begin
                            b:=a[j,n1];
                            c:=a[i,j];
                            aa.re:=aa.re-c.re*b.re+c.im*b.im;
                            aa.im:=aa.im-c.re*b.im-c.im*b.re
                          end;
                        a[i,n1]:=aa;
                        x[i]:=aa
                      end
                  end
         end
end;

end.
