# PalmPal 🌴🤖

PalmPal is a recommendation project, where we create a chatbot. This chatbot is created using the open-source Llama 3 LLM model from Meta.

Particularly, we're using the [**Llama2-7B**](https://replicate.com/a16z-infra/llama7b-v2-chat) model deployed by the Andreessen Horowitz (a16z) team and hosted on the [Replicate](https://replicate.com/) platform.

This app was refactored from [a16z's implementation](https://github.com/a16z-infra/llama2-chatbot) of their [LLaMA2 Chatbot](https://www.llama2.ai/) to be light-weight for deployment to the [Streamlit Community Cloud](https://streamlit.io/cloud).

## Demo Chatbot Website

[![Streamlit App](https://static.streamlit.io/badges/streamlit_badge_black_white.svg)](https://palmpalchatbot.streamlit.app/)

## Demo API Website
- https://icp-t02-grp4-api.onrender.com
- https://icp-t02-grp4-api.onrender.com/docs


# TokoSawit Product Recommendation API Project

This project is a product recommendation API for the TokoSawit platform.

## Requirements

To develop on this project, you need to have the following installed:

1. [Docker Desktop](https://docs.docker.com/get-docker/)
2. [pgAdmin](https://www.pgadmin.org/download/)

## Directory Structure

```
.
.
├── app/                   
│   ├── main.py            # FastAPI app
│   └── requirements.txt   # Python dependencies
├── frontend/              # <--- ✅ Frontend folder (add this)
│   ├── public/            # Static assets (images, icons, etc.)
│   ├── src/               # Source code (JS/TS, React, etc.)
│   ├── dist/ or build/    # Compiled static files (to be served)
│   └── index.html         # Entry HTML file if using plain HTML/CSS/JS
├── docs/                  
├── jupyter/              
│   └── work/              
│       └── notebook.ipynb 
├── api.yaml               
├── database.sql           
└── README.md              

```

## Running the project

1. Start the project. To start the project, you need to go to Terminal or Command Prompt and run the following command:

```bash
docker compose up --build
```

The `--build` flag will build the images again. This is useful if you have changed the Dockerfile, say, to add more Python packages.

2. Wait until the project is running. You can access below URLs:

- API Documentation [(http://localhost:8001/)](http://localhost:8001/)
- Jupyter Notebook [(http://localhost:8888)](http://localhost:8888)
- API [(http://localhost:8000)](http://localhost:8000)

3. You can stop the project by running:

```bash
docker compose down --volumes
```

The `--volumes` flag will remove the volumes associated with the containers.

4. If you want to remove the existing data for PostgreSQL, you can remove all files inside the `postgres/data` directory.
