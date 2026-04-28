This project is a continuation of the Czech bank analysis project.

The objective was to build 3 machine learning models and see which would best predict loan default.
This model would be used in a bank's approval process and flag high risk applications before loan is approved
  It was crucial that the information used in the model would be accurate.
  We did not use any transaction data that occurred AFTER the loan was issued. Everything we feed the model must be information the bank would have had at the point of making the lending decision.

  The meet the outlined objectives, the following was done
    I joined the loan, credit card, client, transactions, demograph and account tables
    From my SQL analysis I pulled important features 
    Loaded the data on python and built 3 machines learning models (Logistical Regression, Decision Tree and Random Forest) to check which would predict the best 
    Evualted the performace of each model and chose the best
