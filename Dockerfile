FROM ruby:2.7.6

# Set the working directory
WORKDIR /app

# Install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the application code
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["rails", "server", "-b", "0.0.0.0"]