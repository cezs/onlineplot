set datafile separator ','
set autoscale xy
plot "< tail -n 30 pow.log" u 0:1 with steps title 'TOTAL', "< tail -n 30 pow.log" u 0:2 with steps title 'GPU', "< tail -n 30 pow.log" u 0:3 with steps title 'CPU'
pause 1
reread
