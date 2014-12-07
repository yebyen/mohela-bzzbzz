This project spits out a table of numbers as a first step toward putting
your student loans at MOHELA on a Beeminder goal.

Do not commit your secrets to the repository if you intend to push your
changes to anywhere public! This is your standard boilerplate Warning!
Ignore it at your own peril.

Put your username into the secrets file and run mohela.rb with no change
to view your own security questions; at Mohela login security procedure
requires answering one of three rotating questions with answers you set.

Copy secrets.rb to super_secret.rb and edit it, or change the require.
Enter Q1,Q2,Q3 etc, A1,A2,A3 with your own question and answer values,
along with your username and password. Each time MOHELA sends a new
challenge which does not already have a response in the secrets file,
you are meant to add it to secret.rb -- it will print the challenge,
then balk and quit. You fix this by adding each challenge and response
to the variables in the secrets file.
