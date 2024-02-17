ARG BASE_IMAGE=dustynv/jetson-inference:r32.6.1
FROM ${BASE_IMAGE}

WORKDIR /nvdli-nano

ENV JUPYTER_WORKDIR=/nvdli-nano
ENV JUPYTER_PASSWORD=hudnano

RUN pip3 install --upgrade pip

RUN pip3 install notebook tensorboard ipywidgets jupyter_bbox_widget && \
    jupyter notebook --generate-config && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter nbextension enable --py jupyter_bbox_widget

RUN echo "c.NotebookApp.password='argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$SDpffsrJIGMN2CpM174upQ\$fhanYRliKLAJToPaLRa4kQlqivagGglF2hBSnsruBNw'">>/root/.jupyter/jupyter_notebook_config.py

RUN git clone https://github.com/NVIDIA-AI-IOT/jetcam.git && \
    cd jetcam && \
    git checkout 508ff3a && \
    python3 setup.py install && \
    cd ../ && \
    rm -rf jetcam

RUN mkdir -p ${JUPYTER_WORKDIR}/object-detection
COPY object-detection/* ${JUPYTER_WORKDIR}/object-detection/

RUN mkdir -p ${JUPYTER_WORKDIR}/classification
COPY classification/* ${JUPYTER_WORKDIR}/classification

# Jupyter listens on 8888.
EXPOSE 8888

CMD /bin/bash -c "jupyter notebook --ip 0.0.0.0 --port 8888 --allow-root &> /var/log/jupyter.log" & \
	echo "allow 10 sec for JupyterLab to start @ http://$(hostname -I | cut -d' ' -f1):8888 (password ${JUPYTER_PASSWORD})" && \
  echo "Jupter notebook logging location:  /var/log/jupyter.log  (inside the container)" && \
  /bin/bash
