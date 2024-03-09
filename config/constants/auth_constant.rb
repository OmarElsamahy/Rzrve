# frozen_string_literal: true

EMAIL_REGEX = /\A(?!.*(?:''|\.\.))[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
PASSWORD_LENGTH = 8..20
PASSWORD_REGEX = /(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*_-])/
