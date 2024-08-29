FROM nxdev

ARG APP_NAME

WORKDIR /app

COPY . .
#RUN npm run build
#RUN mkdir -p /usr/local/lib/alloy
#RUN mv /app/apps/scripts/docker-entrypoint.sh /usr/local/lib/alloy/
#RUN chmod 755 /usr/local/lib/alloy/docker-entrypoint.sh
#RUN ln -s -f /usr/local/lib/alloy/docker-entrypoint.sh /usr/local/bin/


#EXPOSE 3000


#ENTRYPOINT ["docker-entrypoint.sh"]
#CMD []
