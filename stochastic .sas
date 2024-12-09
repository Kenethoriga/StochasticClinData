/* Importing the dataset */
proc import datafile="/home/u64050308/sasuser.v94/COLORECTALCANCERCLIN_DATA_2023-06-06_0620.csv"
    out=colorectal_data
    dbms=csv
    replace;
    getnames=yes;
run;

/* Simulating GBM for 'age' */
data GBMSimulation;
    set colorectal_data; /* Use the imported dataset */
    retain time 0;
    
    /* Parameters */
    mu = 0.01; /* Drift rate */
    sigma = 0.05; /* Volatility */
    dt = 1; /* Time step */
    X = age; /* Starting with the 'age' column */
    
    /* Check for non-missing values of 'age' */
    if not missing(X) then do;
        /* Simulation */
        do i = 1 to 100; /* Simulate for 100 time steps */
            time + dt;
            dW = rannor(12345) * sqrt(dt); /* Random normal variable */
            X = X * exp((mu - 0.5 * sigma**2) * dt + sigma * dW); /* GBM formula */
            output;
        end;
    end;
run;

/* Plot the GBM Simulation */
proc sgplot data=GBMSimulation;
    series x=time y=X / lineattrs=(color=green thickness=2);
    title "General Brownian Motion Simulation for 'age'";
run;

