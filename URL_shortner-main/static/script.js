async function shortenUrl() {
    const longUrlInput = document.getElementById('longUrl');
    const resultContainer = document.getElementById('result');
    const shortUrlInput = document.getElementById('shortUrl');
    const errorElement = document.getElementById('error');
    
    // Reset previous results
    resultContainer.classList.remove('hidden');
    errorElement.classList.add('hidden');
    
    const longUrl = longUrlInput.value.trim();
    
    if (!longUrl) {
        errorElement.textContent = 'Please enter a URL';
        errorElement.classList.remove('hidden');
        return;
    }

    // Add http:// if no protocol is specified
    const urlToShorten = longUrl.startsWith('http://') || longUrl.startsWith('https://') 
        ? longUrl 
        : `https://${longUrl}`;
    
    try {
        const response = await fetch('/shorten', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ long_url: urlToShorten }),
        });
        
        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.detail || 'Failed to shorten URL');
        }
        
        const shortUrl = `${window.location.origin}${data.short_url}`;
        shortUrlInput.value = shortUrl;
        
        // Clear the input
        longUrlInput.value = '';
        
    } catch (error) {
        errorElement.textContent = `Error: ${error.message}`;
        errorElement.classList.remove('hidden');
    }
}

function copyToClipboard() {
    const shortUrlInput = document.getElementById('shortUrl');
    shortUrlInput.select();
    document.execCommand('copy');
    
    // Show feedback
    const button = shortUrlInput.nextElementSibling;
    const originalText = button.textContent;
    button.textContent = 'Copied!';
    button.style.backgroundColor = 'var(--success-color)';
    
    setTimeout(() => {
        button.textContent = originalText;
        button.style.backgroundColor = '';
    }, 2000);
}

// Add keyboard support
document.getElementById('longUrl').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        shortenUrl();
    }
}); 