# Docker-in-Docker CTF

🎯 **Docker-in-Docker CTF** is a Capture The Flag challenge that can be deployed using Docker or as a VirtualBox image. Follow the instructions below to set up and start playing!

---

## 🚀 Deployment Options

### 1. 🎓 TryHackMe

Complete this CTF on TryHackMe:

- Join the room [here](https://tryhackme.com/jr/docker-ctf).
- Launch the provided machine and start solving the challenge.

---

### 2. 🐳 Prebuilt Docker Image *(Recommended)*

1. Pull docker-ctf image from Docker-Hub

```bash
sudo docker image pull ilolm/docker-ctf
```

2. Then, run the Docker container with the following command:

```bash
sudo docker container run -it --rm --privileged --hostname docker-ctf --name docker-ctf -p 8080:8080 -p 22:22 -p 23:23 -p 3306:3306 ilolm/docker-ctf
```

3. After that wait for internal docker compose to be deployed.

*Note: If you use -d option(you will not see the docker compose deployment progress)*

---

### 3. 🔧 Build the Docker Image manually

If you prefer to build the Docker image yourself, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/ilolm/docker-CTF.git
    cd docker-CTF
    ```

2. Build the Docker image:

    ```bash
    sudo docker image build -t docker-ctf:latest .
    ```

3. Run the Docker container:

    ```bash
    sudo docker container run -it --rm --privileged --hostname docker-ctf --name docker-ctf -p 8080:8080 -p 22:22 -p 23:23 -p 3306:3306 docker-ctf
    ```

4. After that wait for internal docker compose to be deployed.

*Note: If you use -d option(you will not see the docker compose deployment progress)*


---

### 4. 💻 VirtualBox Image

Alternatively, you can deploy the CTF using a VirtualBox image:

1. Download the VirtualBox image from the [releases section](https://github.com/ilolm/docker-CTF/releases).

2. Open VirtualBox, and either create a new VM or import the downloaded OVA file.

3. Set the network adapter to **Bridged Adapter** mode to ensure the VM can be accessed on the same network as your host machine.

4. Start the VM and note the assigned IP address.

5. Access the CTF challenge via the assigned IP address.

---

## 🔗 CTF Flag Verification Site

For verifying flags, use the [CTF Flag Verification Site](https://github.com/ilolm/ctf-flag-verification-site.git). This site is specifically designed to work seamlessly with this CTF challenge.

---

## 📜 Important Rules

- **🚫 No Peeking:** **Do not attempt to access or open the flags during the Docker build process.** The real challenge is finding them through gameplay. 💡
- **🎉 Have Fun:** This CTF is designed to challenge your skills and knowledge, so enjoy the process and learn as you go!

---

Happy hacking! 🚀
