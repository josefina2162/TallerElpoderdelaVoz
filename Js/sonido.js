document.getElementById('startButton').addEventListener('click', startAudioCapture);

function startAudioCapture() {
    const audioContext = new (window.AudioContext || window.webkitAudioContext)();
    const analyser = audioContext.createAnalyser();
    const canvas = document.getElementById('canvas');
    const canvasContext = canvas.getContext('2d');

    navigator.mediaDevices.getUserMedia({ audio: true })
        .then(function(stream) {
            const source = audioContext.createMediaStreamSource(stream);
            source.connect(analyser);
            analyser.connect(audioContext.destination);

            analyser.fftSize = 256;
            const bufferLength = analyser.frequencyBinCount;
            const dataArray = new Uint8Array(bufferLength);

            function drawSquare() {
                analyser.getByteFrequencyData(dataArray);
                const amplitude = dataArray.reduce((a, b) => a + b) / bufferLength;

                if (amplitude > 80) {
                    canvasContext.clearRect(0, 0, canvas.width, canvas.height);
                    canvasContext.fillStyle = 'red';
                    canvasContext.fillRect(50, 50, 100, 100);
                } else {
                    canvasContext.clearRect(0, 0, canvas.width, canvas.height);
                }

                requestAnimationFrame(drawSquare);
            }

            drawSquare();
        })
        .catch(function(error) {
            console.error('Error al acceder al micrófono:', error);
        });
}