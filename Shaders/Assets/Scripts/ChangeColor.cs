using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeColor : MonoBehaviour
{

    private Renderer rend;
    private Color newColor;
    private float timer;

    void Awake()
    {
        rend = GetComponent<Renderer>();
    }
    void Start()
    {
        newColor = Vector4.one;
        timer = 0;
    }

    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;
        print(timer);
        if (timer > 2)
        {
            print("Change");
            newColor.r = Random.Range(0f, 1f);
            newColor.g = Random.Range(0f, 1f);
            newColor.b = Random.Range(0f, 1f);
            rend.material.SetColor("_Color", newColor);
            timer = 0;
        }
    }
}
