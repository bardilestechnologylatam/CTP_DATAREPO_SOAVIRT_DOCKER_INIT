FROM parasoft/ctp

ARG USER_ID
ARG GROUP_ID
ARG USER_NAME

ENV PARASOFT_HOME=/usr/local/parasoft/ 

USER root:root
RUN chmod 777 -R /usr/local/parasoft
RUN groupadd --gid $GROUP_ID $USER_NAME && useradd --create-home --gid $USER_NAME --home $PARASOFT_HOME --uid $USER_ID $USER_NAME && chown -R ${USER_ID}:0 ${PARASOFT_HOME} && chmod -R g=u ${PARASOFT_HOME}
RUN ls -l  /usr/local/parasoft/ctp/hsqldb

