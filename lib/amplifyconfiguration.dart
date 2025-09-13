const amplifyconfig = '''{
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify/cli",
        "Version": "0.1.0",
        "IdentityManager": {"Default": {}},
        "CognitoUserPool": {
          "Default": {
            "PoolId": "us-west-1_2ELVjRok7", 
            "AppClientId":
                "2nftmu8iq8uulci47vt2vso482",
            "AppClientSecret":
                "8rfvf54fmd5t2k760eukvmon978fajv96ulpmhu7flmle3u16kp", 
            "Region": "us-west-1" 
          }
        },
        "Auth": {
          "Default": {"authenticationFlowType": "USER_SRP_AUTH"}
        },
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": "us-west-1_2ELVjRok7",
              "Region": "us-west-1"
            }
          }
        }
      }
    }
  },
  "storage": {
    "plugins": {
      "awsS3StoragePlugin": {
        "bucket": "omega-storage",
        "region": "mx-central-1",
        "defaultAccessLevel": "guest"
      }
    }
  }
}''';
