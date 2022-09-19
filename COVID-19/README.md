## Project Title
COVID-19 Data Visualization Using Python

## Project Description
In this project I'm going to use COVID-19 dataset consisting of data-related cumulative number of confirmed, recovered, and deaths cases in different countries around the Globe to answer these questions:
1. How does Global Spread of the virus look like?
2. How intensive the spread of the virus has been in Nigeria?
3. How has COVID-19 national lockdown and self-isolations in Nigeria impacted on COVID-19 transmission?

### Methods Used
- Data Cleaning
- Data Interpretation
- Data Vizualisation

### Technologies
- Python
- Colab (google cloud based notebook)
- NumPy, Pandas, Matplotlib, Plotly

## Documentation
[Data Set](https://raw.githubusercontent.com/datasets/covid-19/master/data/countries-aggregated.csv)


## Table of Contents in the Notebook

1. Importing modules and getting familiar with the dataset  

    1.1. Importing modules    
    1.2. Loading the dataset  
    1.3. Let's check the dataframe  
    1.4. Let's check the shape of the dataframe
    
2. Preprocessing  
    
    2.1. Let's get all of the rows in which the Confirmed column is more than zero  
    2.2. Let's see global spread of COVID-19  
    2.3. Let's see global deaths of COVID-19
    
3. Visualizing how intensive the COVID-19 Transmission has been in Nigeria

    3.1. Let's see data related to Nigeria  
    3.2. Let's select the columns that we need  
    3.3. Let's calculate the first derivation of confirmed column  
    3.4. Let's visualize that relationship  
    3.5. Let's calculate the maximum infection rate or the maximum number off new infected cases in one day in Nigeria  
    3.6. Let's calculate maximum infection rate for all of the countries    
    3.7. Let's create a new dataframe   
    3.8. Let's plot the barchart: maximum infection rate of each country
    
4. How national lockdown impacts COVID-19 transmission in Nigeria 

    4.1. Lets make variables with the lockdown start date and a month later  
    4.2. Let's get data related to Nigeria and check the dataframe  
    4.3. Let's calculate the infection rate in Nigeria  
    4.4. Let's do the visualization  

5. How national lockdown impacts COVID-19 active cases in Nigeria 

    5.1. Let's check the dataframe before  
    5.2. Let's calculate the deaths rate  
    5.3. Let's check the dataframe after  
    5.4. Let's plot a line chart to compare COVID-19 national lockdown impacts on spread of the virus and number of active cases  
    5.5. Let's normalize the columns  
    5.6. Let's plot the line chart again  
