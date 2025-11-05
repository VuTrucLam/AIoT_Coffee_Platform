import bcrypt

class User:
    def __init__(self, name, email, farm_name, account_type, password):
        self.name = name
        self.email = email
        self.farm_name = farm_name
        self.account_type = account_type
        self.password = self.hash_password(password)

    def hash_password(self, password):
        salt = bcrypt.gensalt()
        return bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')

    @staticmethod
    def check_password(password, hashed):
        return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))
    
    def to_dict(self):
        return {
            "name": self.name,
            "email": self.email,
            "farm_name": self.farm_name,
            "account_type": self.account_type,
            "password": self.password
        }
