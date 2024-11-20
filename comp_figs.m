
figure
plot(data.trial{1,1}(1,:)./1000,blinks*5000,'b')
hold on
plot(data.trial{1,1}(1,:)./1000,detect_sv,'k')
hold on
plot(data.trial{1,1}(1,:)./1000,blinks_sv*2000,'r')
