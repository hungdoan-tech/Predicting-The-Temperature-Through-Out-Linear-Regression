FROM python:latest
#The python image uses current dir . in docker image as the default run directory:
WORKDIR .
#Copy from the local current dir to the image workdir:
COPY . .
#Install any dependencies listed in our ./requirements.txt:
RUN pip install --no-cache-dir -r requirements.txt
#Run api.py on container startup:
CMD [ "python", "./MainAPI.py" ]
