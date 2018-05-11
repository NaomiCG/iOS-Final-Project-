# Cache

Simple, sleak, easy-to-use financial advisor app targeted towards young adults with little to no economic know-how (HS grads, college grads, anyone transitioning into financial independence).  The main feature of the app is a live, interactive chart, the goal of which is to help users visualize where their money is going so that they can be better prepared for the financial reality, and to help them plan for the future.

### App Flow

Once running, a user can choose to Sign Up for Cache, or Log In to their existing account.  All account verification runs through Firebase.

Assuming you are a new user, in order to be signed up you will be asked for your email, a password, your name, and birthday.  These values cannot be changed once the account is created.  After this initial screen, the user will be directed to a new view where they enter their relevant financial info.  The users enters their location (city & state, used for tax calculations), their monthly income (along with employer name), and all their monthly expenses (for the sake of this project this includes: student loans, credit card bill, rent, and utilities).

After the user saves this information they are directed to the main view -- the chart.  There they can see the breakdown, both visually with the chart and in plain text, of where their money is going every month.

Once their initial data has been captured and saved (in Firebase), users can also use the comparison feature to visualize their finances if they were to change jobs, states, rent, etc.

### App Features

Interactive, colorful chart: depicts an easy-to-understand breakdown of the user's expenses.

Comparison feature: allows the user to compare their current finances to a different financial situation (ie new job, new city, new apartment, bigger credit card bill).

Helpful info: pink question marks indicate a button that the user can click on to receive more information.  They are used to inform users about various financial terms they may not fully understand (loans, net income, etc.).

Alerts: alert the user when their finances are a little troubling, for example if they are spending too much of their paycheck on rent.

Gorgeous, sleek UI experience.
