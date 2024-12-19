package com.airsoftauctions.app

import io.flutter.embedding.android.FlutterActivity
import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.webkit.WebChromeClient
import android.webkit.ValueCallback
import android.webkit.WebView

import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class MainActivity : FlutterActivity() {
    private var filePathCallback: ValueCallback<Array<Uri>>? = null
    private val FILE_CHOOSER_REQUEST_CODE = 1001

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == FILE_CHOOSER_REQUEST_CODE) {
            val results: Array<Uri>? = if (resultCode == Activity.RESULT_OK) {
                if (data != null) {
                    arrayOf(Uri.parse(data.dataString))
                } else {
                    null
                }
            } else {
                null
            }
            filePathCallback?.onReceiveValue(results)
            filePathCallback = null
        }
    }

    fun setupFileChooser(webView: WebView) {
        webView.webChromeClient = object : WebChromeClient() {
            override fun onShowFileChooser(
                webView: WebView,
                filePathCallback: ValueCallback<Array<Uri>>,
                fileChooserParams: FileChooserParams
            ): Boolean {
                this@MainActivity.filePathCallback?.onReceiveValue(null)
                this@MainActivity.filePathCallback = filePathCallback

                val intent = fileChooserParams.createIntent()
                try {
                    startActivityForResult(intent, FILE_CHOOSER_REQUEST_CODE)
                } catch (e: Exception) {
                    this@MainActivity.filePathCallback = null
                    return false
                }
                return true
            }
        }
    }

    private fun checkStoragePermission(): Boolean {
        val permission = Manifest.permission.READ_EXTERNAL_STORAGE
        return ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestStoragePermission() {
        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE), 101)
    }
}
