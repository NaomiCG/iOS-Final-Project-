# Cache

Simple, sleak, easy-to-use financial advisor app targeted towards young adults with little to no economic know-how (HS grads, college grads, anyone transitioning into financial independence).  The main feature of the app is a live, interactive chart, the goal of which is to help users visualize where their money is going so that they can be better prepared for the financial reality, and to help them plan for the future.

### Running the App

Inside the folder cache_app, run the file:
```
cache_app.xcworkspace
```
indicated by white icon, rather than the typical blue.

**Run the Cache app on an iPhone X Simulator.**

### App Flow

Once running, a user can choose to Sign Up for Cache, or Log In to their existing account.  All account verification runs through Firebase.

Assuming you are a new user, in order to be signed up you will be asked for your email, a password, your name, and birthday.  These values cannot be changed once the account is created.  After this initial screen, the user will be directed to a new view where they enter their relevant financial info.  The users enters their location (city & state, used for tax calculations), their monthly income (along with employer name), and all their monthly expenses (for the sake of this project this includes: student loans, credit card bill, rent, and utilities).

After the user saves this information they are directed to the main view -- the chart.  There they can see the breakdown, both visually with the chart and in plain text, of where their money is going every month.

### App Features

Interactive, colorful chart: depicts an easy-to-understand breakdown of the user's expenses.

Helpful info: pink question marks indicate a button that the user can click on to receive more information.  They are used to inform users about various financial terms they may not fully understand (loans, net income, etc.).

Alerts: alert the user when their finances are a little troubling, for example if they are spending too much of their paycheck on rent.

Gorgeous, sleek UI experience.

### How to Use

If you are a new user, upon sign up you will be directed to the *edit info* page, where you can enter your financial information.

If you are a returning user, upon being directed to the *main screen* (chart page), you can press the edit button in the top right corner in order to access and change that information.

To access the chart, either log in to an existing account, or sign up, enter your information, and press "save."  This will lead you to the *main screen* view, where you can see the text breakdown and donut chart of your financial info.

The chart is interactive, it can be swiveled and turned, and additionally the individual sections can be expanded by tapping on them.

The access the information snippets in the app, there are a few different places.  On the *edit info* page, there are info snippets for both the loans section and the rent section.  On the *main screen* there is an info snippet next to the income labels.

## Built With

* XCode 9
* Swift 4
* Firebase
* Charts SDK https://github.com/danielgindi/Charts

## Troubleshooting


If you run into *code signing* errors following the instructions at:
https://stackoverflow.com/questions/37806538/code-signing-is-required-for-product-type-application-in-sdk-ios-10-0-stic

If you run into issues with the Charts, visit the document at the SDK:
https://github.com/danielgindi/Charts/issues

## Authors

* Naomi Gheorghe
* Kelly Williams
* Martin Brekke
