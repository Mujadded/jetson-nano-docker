ARG BASE_IMAGE=nvcr.io/nvidia/dli/dli-nano-ai:v2.0.1-r32.6.1
FROM ${BASE_IMAGE}

ENV JUPYTER_PASSWORD=hudnano
ENV JUPYTER_WORKDIR=/nvdli-nano

RUN python3 -c "from notebook.auth.security import set_password; set_password('${JUPYTER_PASSWORD}', '/root/.jupyter/jupyter_notebook_config.json')"


RUN rm -rf ${JUPYTER_WORKDIR}/*

RUN mkdir -p ${JUPYTER_WORKDIR}/object-detection
COPY object-detection/* ${JUPYTER_WORKDIR}/object-detection/

RUN mkdir -p ${JUPYTER_WORKDIR}/classification
COPY classification/* ${JUPYTER_WORKDIR}/classification

CMD /bin/bash -c "cd $JUPYTER_WORKDIR && jupyter lab --ip 0.0.0.0 --port 8888 --allow-root &> /var/log/jupyter.log" & \
	echo "allow 10 sec for JupyterLab to start @ http://$(hostname -I | cut -d' ' -f1):8888 (password ${JUPYTER_PASSWORD})" && \
	echo "JupterLab logging location:  /var/log/jupyter.log  (inside the container)" && \
	/bin/bash