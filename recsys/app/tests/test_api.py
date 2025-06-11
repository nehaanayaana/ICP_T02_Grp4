import requests

url = "https://tokosawit-product-recommendation.api.sawitpro.com/api/v1/ecommerce/recommendations/user/02b2724f-0227-4c94-a7a0-8cf37f7aee70"

def test_user_recommendations():
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise an HTTPError if the response was unsuccessful
        data = response.json()
        print(f"Status Code: {response.status_code}")
        print("Response Data:", data)
    except requests.exceptions.HTTPError as http_err:
        print(f"HTTP error occurred: {http_err}")
    except requests.exceptions.RequestException as req_err:
        print(f"Request error occurred: {req_err}")
    except Exception as err:
        print(f"An unexpected error occurred: {err}")

if __name__ == "__main__":
    test_user_recommendations()
