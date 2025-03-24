FROM python:3.9.21-bookworm
WORKDIR /app
COPY ./app.py .
COPY ./requirements.txt .
RUN pip install -r requirements.txt 
CMD ["python3", "app.py"]
#TODO: Create Dockerfile
#TODO: Build image locally
#TODO: Push docker image to ECR (maybe you need to create one) with tag v1