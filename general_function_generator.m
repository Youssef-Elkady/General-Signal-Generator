%main fucntion which has same name as the file that runs the whole code.
function part2
    fs = getFrequency();
    starting_time = input('Enter Signal Starting Time: ');
    ending_time = getEndingTime(starting_time);
    breakpoints_num = getBreakPoints_num(); 
    breakpoints = getBreakpoints(starting_time, ending_time, breakpoints_num);   
    signal = getSignal(breakpoints, fs);
    signal_time = createSignalTime(starting_time, ending_time, fs);
    plot(signal_time, signal);
    title('original signal');
    xlim([starting_time-1 ending_time+1]);
    modify(signal_time, signal);
end

% function to get a frequency above 0 from the user
function fs = getFrequency()
    fs = input('Enter the Sampling Frequency: ');
    while (fs<=0)
        fs = input('Enter a Sampling Frequency above 0: ');
    end    
end     

%function to get the ending time of the signal from the user
%ending time must be after the starting time of the signal

function ending_time = getEndingTime(starting_time)
ending_time = input('Enter Signal Ending Time: ');
    while (ending_time<= starting_time)
        ending_time = input('Enter End Time which is after %d: ',starting_time);
    end    
end

%function to get the number of breakpoints from the user
% it makes sure the number of breakpoints is not a negative number

function breakpoints_num = getBreakPoints_num()
    breakpoints_num = input('Enter the number of breakpoints: ');
    while (breakpoints_num<0)
        breakpoints_num = input('Enter breakpoints number equal or above 0: ');
    end    
end 

%function that gets the breakpoints and sorts them ascendingly in the end

function breakpoints = getBreakpoints(starting_time, ending_time, breakpoints_num)
%breakpoints is initialized containing start and end time
    breakpoints = [starting_time, ending_time];
    for i = 1:breakpoints_num
        fprintf('enter Breakpoint %d: ',i);
        new_breakpoint = input('');
        %validates that breakpoints are withing the signal time
        while (new_breakpoint <= starting_time) || (new_breakpoint >= ending_time)
            fprintf('Input out of range. Please Enter a value between %d and %d\n', starting_time, ending_time);
            new_breakpoint = input('Enter Breakpoint %d: ', i);
        end 
        %adding new breakpoint in the before last position
        breakpoints = [breakpoints(1:end-1) new_breakpoint breakpoints(end)];
    end
    %sorts the breakpoints in the end
    breakpoints = sort(breakpoints);   
end

%function the gets the users desired signal and creats it
%it creats it by calling its unique funtion for each signal

function signal = getSignal(breakpoints, fs)
    %signals in initilized empty then added to it the desired signals 
    %desired signals amount depend on number of breakpoints
    signal = [];
    fprintf(' enter the desired signals\n');
    for i=1:size(breakpoints,2)-1        
        fprintf('Enter the type of signal you want that starts from %d and ends at %d: \n',breakpoints(i), breakpoints(i+1));
        fprintf('type 1 for dc signal\n');
        fprintf('type 2 for ramp signal\n');
        fprintf('type 3 for polynomial signal\n');
        fprintf('type 4 for exponential signal\n');
        fprintf('type 5 for sinusoidal signal\n');
        choice = input('');
        starting_time = breakpoints(i);
        ending_time = breakpoints(i+1);
        %added signal is initilized empty before the user inputs the
        %desired signal
        added_signal=[];
        switch choice
            case 1
                added_signal = createDC(starting_time, ending_time, fs);
            case 2
                added_signal = createRamp(starting_time, ending_time, fs);
            case 3
                added_signal = createPolynomial(starting_time, ending_time, fs);
            case 4
                added_signal = createExponential(starting_time, ending_time, fs);
            case 5
                added_signal = createSinusoidal(starting_time, ending_time, fs);
                
            otherwise
                disp('unsupported command')
        end
        fprintf('\n');
        %signal is appended to include the added signal in the end
        signal = [signal added_signal];
                    
    end            
end



%unique functions for each type of signal to create it

function dc_signal = createDC(starting_time, ending_time, fs)
    fprintf('Enter DC signal parameters\n');
    amplitude = input('Enter Amplitude: ');
    signal_time = createSignalTime(starting_time, ending_time, fs);
    dc_signal = 0*signal_time + amplitude;
end


function ramp_signal = createRamp(starting_time, ending_time, fs)
    fprintf('Enter Ramp signal parameters\n');
    slope = input('Enter ramp Slope: ');
    intercept = input('Enter Y Intercept: ');
    signal_time = createSignalTime(starting_time, ending_time, fs) - starting_time;
    ramp_signal = slope*signal_time + intercept;
end



function polynomial_signal = createPolynomial(starting_time, ending_time, fs)
    fprintf('Enter Polynomial signal parameters\n');
    order = input('Enter order of Polynomial: ');
    % checks that order is greater than 0
    while (order<0)
        order = input('Enter an order greater than 0: ');      
    end
    %we use powers to store the polynomial powers coefficients 
    powers = zeros(1,order+1);
    %for loop used to store said powers coefficients
    for i=1:order+1
        fprintf('Enter amplitude of power %s%s', num2str(order+1-i),' : ');
        powers(i) = input('');
    end    
    %create signal using signal time function and polyval built in function
   
    signal_time = createSignalTime(starting_time, ending_time, fs) - starting_time;
    polynomial_signal = polyval(powers,signal_time);
end


function exponential_signal = createExponential(starting_time, ending_time, fs)
    fprintf('Enter Exponential signal parameters\n');
    exponent = input('Enter Exponent: ') ;
    amplitude = input('Enter Amplitude: ');
    signal_time = createSignalTime(starting_time, ending_time, fs) - starting_time;
    exponential_signal = amplitude.* exp(exponent.*signal_time);
end



function sinusoidal_signal = createSinusoidal(starting_time, ending_time, fs)
    fprintf('Enter Sinusoidal signal parameters\n');
    amplitude = input('Enter Amplitude: ');
    frequency = input('Enter Frequency: ');
    while (frequency<=0)
        frequency = input('Enter Frequency above 0: ');
    end    
    phase = input('Enter Phase: ');
    signal_time = createSignalTime(starting_time, ending_time, fs) - starting_time;
    sinusoidal_signal = amplitude * sin(2*pi*frequency*signal_time + deg2rad(phase));

    
end


%Signal Time Generator

function signal_time = createSignalTime(starting_time, ending_time, fs)
    signal_time = linspace(starting_time, ending_time, fs*(ending_time- starting_time));
end


%function that asks the user which type of signal modification is required
% it then calls the required modification function in it
function  modify(signal_time, signal)
    while true
        fprintf('type 1 for Amplitude Scaling\n');
        fprintf('type 2 for Time Reversal\n');
        fprintf('type 3 for Time Shifting\n');
        fprintf('type 4 for Time Expanding\n');
        fprintf('type 5 for Time Compression\n');
        fprintf('type 6 to Display the latest version of the signal\n');
        fprintf('type 7 to Exit the program\n');
        choice = input('Please enter the operation you would like to apply on the signal: ');
      
        switch choice
            case 1
                signal = Scale(signal);
            case 2
                signal_time = reverse(signal_time);
            case 3
                signal_time = timeShift(signal_time);
            case 4
                signal_time = expandTime(signal_time);     
            case 5
                signal_time = compressTime(signal_time);
            case 6
                plot(signal_time, signal);
                title('modified signal');
                
            case 7
                fprintf('Thanks for using this program\n');
                return
                
            otherwise
                disp('unsupported command')
        end
        fprintf('\n');
            
    end

end



%unique function for each type of signal modification

%in scaling we simply multiply the signal with the scaling factor
function scaled_signal = Scale(signal)
    scaling_factor = input('Enter Scaling factor: ');
    scaled_signal = signal*scaling_factor;
end

% in time reversal, we simply multiply signal time with (-1)
function reversed_time = reverse(signal_time)
    reversed_time = (-1)*signal_time;
end

%in time shift, we subtract the time shift from the signal time
function shifted_time = timeShift(signal_time)
    time_shift = input('Enter Value of the Time Shift: ');
    shifted_time = signal_time - time_shift;
end

%in time expansion, we multiply the signal time with the expansion factor
function expanded_time  = expandTime(signal_time)
    expansion_factor = input('Enter the Expansion Factor: ');
    expanded_time = signal_time*expansion_factor ;
end

%in time compression, we divide the signal time with the compression factor
function compressed_time = compressTime(signal_time)
    compression_factor = input('Enter the Compression Factor: ');
    compressed_time = signal_time/compression_factor ;
end

