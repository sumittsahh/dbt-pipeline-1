 # try:
    #     cursor.execute(f"create role if not exists {role};")
    #     print(f"✅ Role {role} created")
    # except Exception as e:
    #     print(f"❌ Failed to create role {role}: {e}")
    
    # try:
    #     cursor.execute(f"grant usage on warehouse {warehouse} to role {role};")
    #     print(f"✅ Successfully granted usage on warehouse {warehouse} to role {role}")
    # except Exception as e:
    #     print(f"❌ Faiiled to grant usage on warehouse {warehouse} to role {role}: {e}")
    
    # try:
    #     cursor.execute(f"grant role {role} to user {os.getenv('your_username')};")
    #     print(f"✅ Successfully granted role {role} to user {os.getenv('your_username')}")
    # except Exception as e:
    #     print(f"❌ Failed to grant role {role} to user {os.getenv('your_username')}: {e}")
    
    # try:
    #     cursor.execute(f"grant all on database {database} to role {role};")
    #     print(f"✅ Successfully granted all on database {database} to role {role}")
    # except Exception as e:
    #     print(f"❌ Failed to grant all on database {database} to role {role}: {e}")
    
    # try:
    #     cursor.execute(f"use role {role};")
    #     print(f"✅ Using role {role}")
    # except Exception as e:
    #     print(f"❌ failed to use role {role}: {e}")