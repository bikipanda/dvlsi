
% Input Patterns
inputpatt0 = [1   1  -1  -1  -1  -1   1   1  -1   1   1  -1   1   1  -1   1   1  -1   1   1  -1   1   1  -1   1   1  -1  -1  -1  -1   1   1   1   1   1   1];
inputpatt1 = [1  -1   1   1   1   1  -1  -1   1   1   1   1   1  -1   1   1   1   1   1  -1   1   1   1   1   1  -1   1   1   1   1  -1  -1  -1   1   1   1];
inputpatt2 = [1   1   1   1   1   1  -1  -1  -1  -1   1   1   1   1   1  -1   1   1  -1  -1  -1  -1   1   1  -1   1   1   1   1   1  -1  -1  -1  -1   1   1];
inputpatt3 = [-1  -1  -1   1   1   1   1   1  -1   1   1   1   1  -1  -1   1   1   1   1   1  -1   1   1   1  -1  -1  -1   1   1   1   1   1   1   1   1   1];
inputpatt4 = [1   1   1   1  -1   1   1   1   1  -1  -1   1   1   1  -1   1  -1   1   1  -1   1   1  -1   1  -1  -1  -1  -1  -1  -1   1   1   1   1  -1   1];
inputpatt5 = [1  -1  -1  -1  -1  -1   1  -1   1   1   1   1   1  -1  -1  -1  -1   1   1   1   1   1   1  -1   1  -1   1   1   1  -1   1   1  -1  -1  -1   1];
inputpatt6 = [1  -1  -1  -1   1   1  -1   1   1   1   1   1  -1  -1  -1  -1   1   1  -1   1   1   1  -1   1  -1   1   1   1  -1   1   1  -1  -1  -1   1   1];
inputpatt7 = [1  -1  -1  -1  -1  -1   1   1   1   1   1  -1   1   1   1   1  -1   1   1   1   1  -1   1   1   1   1   1  -1   1   1   1   1   1  -1   1   1];
inputpatt8 = [1  -1  -1  -1  -1   1  -1   1   1   1   1  -1   1  -1  -1  -1  -1   1  -1   1   1   1   1  -1  -1   1   1   1   1  -1   1  -1  -1  -1  -1   1];
inputpatt9 = [1  -1  -1  -1  -1   1   1  -1   1   1  -1   1   1  -1  -1  -1  -1   1   1   1   1   1  -1   1   1   1   1   1  -1   1   1  -1  -1  -1  -1   1];


train = 6; % Number of training patterns
totpix = 36;% Total neurons
noofinputs = 10;

inputmatt = [inputpatt0; inputpatt1; inputpatt2; inputpatt3; inputpatt4; inputpatt5; inputpatt6; inputpatt7; inputpatt8; inputpatt9];

weightmatt1 =0;



% weightmatrix training
for n =1:train
  weightmatt1 = weightmatt1 + inputmatt(n,1:totpix)'*inputmatt(n,1:totpix);
end
    
weightmatt1 = (weightmatt1 - train*eye(totpix))% Making weight matrix diagonal elements zero



%showing energy of every input patterns trained
for m=1:train
    energy(m)=0;
    for i= 1:36
        for j= 1:36
   
        energy(m)= (energy(m) + (-0.5)*weightmatt1(i,j).* inputmatt(m,i) .* inputmatt(m,j));
        end
    end
    disp("energy of the symols")
    disp(energy(m));
end


noisy_input = inputmatt';
% updated_noisy_input = noisy_input(1:totpix,1);  %standard inputs

% The noisy version of inputs for test
 updated_noisy_input = [1   1   1   1  1   1   1   1   1  -1  -1   1   1   1  1   1  -1   1   1  -1   1   1  -1   1  1  -1  -1  -1  -1  1   1   1   1   1  -1   1]';

%below are input column vectors
updated_noisy_input1 = updated_noisy_input;
updated_noisy_input2 = updated_noisy_input;




% showing the input noisy 
test1 = updated_noisy_input2';
  subvector11 = test1(1:6);
  subvector21 = test1(7:12);
  subvector31 = test1(13:18);
  subvector41 = test1(19:24);
  subvector51 = test1(25:30);
  subvector61 = test1(31:36);
  plotfinalvect1 = [subvector11;subvector21;subvector31;subvector41;subvector51;subvector61];
 subplot(1,2,1),imshow(plotfinalvect1);


found = 0;
counter = 15;
% to fire neurons in randomly 
random=[11 20 34 6 22 35 4 9 36 23 1 26 2 3 32 17 15 21 28 25 13 8 5 18 31 7 19 10 30 12 14 16 29 33 24 27];


while found == 0 && counter ~= 0


    for p =1:totpix
        k=random(p);
   updated_noisy_input2(k) =  weightmatt1(k,1:totpix) * updated_noisy_input2;
  
    if updated_noisy_input2(k) >= 0
    updated_noisy_input2(k) = 1;
%   elseif updated_noisy_input2(k)
%     updated_noisy_input2(k) = updated_noisy_input1(k);
    else
     updated_noisy_input2(k) = -1;
    end
    end
    
 
   

           


updated_noisy_input';
updated_noisy_input1'  % showing all neuron states before update by 1 step unit
updated_noisy_input2'  % Showing all neuron dtates after update by 1 step unit


%for k = 1:totpix
%if updated_noisy_input2(k) >= 0
%  updated_noisy_input2(k) = 1;
%else
%  updated_noisy_input2(k) = -1;
%endif
%endfor  
%
%  matched = 0;
%for k = 1:totpix
%  if updated_noisy_input2(k) == updated_noisy_input1(k)
%    
%  else
%    matched(k) = 0;
%    
%endfor
%  
  


   % comparison before update and after update
  compareRes = updated_noisy_input2 == updated_noisy_input1;
 
   disp("comparison!");
   compareRes'

   
   
   
   
   % energy of updated symbol not updated
    noisenergy(m)=0;
    for i= 1:36
        for j= 1:36
   
        noisenergy(m)= ((noisenergy(m) + (-0.5)*weightmatt1(i,j).* updated_noisy_input1(i)' .* updated_noisy_input1(j)'));
        end
    end
    disp("energy of the symols noisy before");
    disp(noisenergy(m));
   
%    energy of updated symbolupdated
    noisenergy(m)=0;
    for i= 1:36
        for j= 1:36
   
        noisenergy(m)= (noisenergy(m) +(-0.5)* weightmatt1(i,j).* updated_noisy_input2(i)' .* updated_noisy_input2(j)');
        end
    end
    disp("energy of the symols noisy after");
    disp(noisenergy(m));
  
    
    
    %checking stopping condition
    if compareRes
     found = 1;
      disp("ran into if condition!!!");
    else
     found = 0;
     disp("ran into else");
     updated_noisy_input1 = updated_noisy_input2; 
    end

counter = counter -1;
disp(counter);  
end

%plotting the vector
   test = updated_noisy_input2';
  subvector1 = test(1:6);
  subvector2 = test(7:12);
  subvector3 = test(13:18);
  subvector4 = test(19:24);
  subvector5 = test(25:30);
  subvector6 = test(31:36);
  plotfinalvect = [subvector1;subvector2;subvector3;subvector4;subvector5;subvector6];

 subplot(1,2,2), imshow(plotfinalvect);