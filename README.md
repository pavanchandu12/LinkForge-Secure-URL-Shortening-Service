

 ** URL Shortener **

A containerized **URL shortener** application built with **FastAPI** and **Redis**, orchestrated using **Docker Compose**.

It allows you to shorten long URLs, generate short codes, store mappings in Redis, and redirect users using the short code.


 **Features**

✅ Shorten any valid URL

✅ Auto-generate random short codes

✅ Persistent Redis storage using Docker volumes

✅ One-command startup with Docker Compose

✅ Built-in static frontend

---

 🏗 **Tech Stack**
 
**FastAPI** (Python 3 async framework)
  
**Redis** (for key-value storage)

**Docker + Docker Compose** (for container orchestration)

**Pydantic** (for request validation)


📦 **Setup (Docker)**

1️⃣ **Clone the repository**

```bash

git clone url

cd url-shortener

```

2️⃣ **Build and run using Docker Compose**

```bash

docker-compose up --build

```

This will:

* Build the FastAPI app image (`web` service)
* 
* Start a Redis container (`redis` service)
* 
* Expose FastAPI on **localhost:8000**
* 
* Expose Redis on **localhost:6379**

3️⃣ **Access the application**

* Main app: [http://localhost:8000](http://localhost:8000)
  
* Swagger docs: [http://localhost:8000/docs](http://localhost:8000/docs)

---

📂 **Project Structure**

```
/static               # Frontend static files (HTML, CSS, JS)

main.py               # FastAPI app

Dockerfile            # Docker image for the FastAPI app

docker-compose.yml    # Multi-service orchestration (FastAPI + Redis)

requirements.txt      # Python dependencies

README.md             # Project documentation

```

---



✅ FastAPI app connects to Redis using the internal Docker network (`REDIS_HOST=redis`)
✅ Redis data is persisted using the named volume `redis_data`

---

📦 **API Endpoints**

| Method | Endpoint        | Description                                      |

| ------ | --------------- | ------------------------------------------------ |

| GET    | `/`             | Serve the main static page                       |

| POST   | `/shorten`      | Accept `{ long_url }` and return `{ short_url }` |

| GET    | `/{short_code}` | Redirect to the original long URL                |

---

### 🌍 **Environment Variables**

| Variable     | Default | Description                      |

| ------------ | ------- | -------------------------------- |

| `REDIS_HOST` | `redis` | Redis service name inside Docker |

| `REDIS_PORT` | `6379`  | Redis port                       |

---

### 💡 **Future Improvements**

* Add expiration time for short links
* User-friendly frontend interface
* Click tracking & analytics
* Custom user-defined short codes
* Rate limiting & abuse prevention

---

### 🐳 **Useful Commands**

| Command                                 | Description                                   |

| --------------------------------------- | --------------------------------------------- |

| `docker-compose up --build`             | Build and start all services                  |

| `docker-compose down`                   | Stop and remove all containers + networks     |

| `docker-compose logs -f`                | Follow logs for all services                  |

| `docker-compose exec web bash`          | Access FastAPI app container shell            |

| `docker volume ls` / `docker volume rm` | Manage Redis persistent volume (`redis_data`) |

---

### 🤝 **Contributing**

Fork the repository
  
Create your feature branch (`git checkout -b feature/YourFeature`)
   
Commit your changes (`git commit -m 'Add YourFeature'`)

Push to the branch (`git push origin feature/YourFeature`)

Open a pull request

